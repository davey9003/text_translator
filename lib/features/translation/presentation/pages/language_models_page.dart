import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/constants/supported_languages.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/error/failures.dart';
import '../../../../features/onboarding/domain/usecases/complete_first_launch_usecase.dart';
import '../../../../features/settings/domain/usecases/get_settings_usecase.dart';
import '../../../../features/settings/domain/usecases/update_settings_usecase.dart';
import '../../../../features/settings/presentation/providers/settings_provider.dart';
import '../../../../app/routes/route_names.dart';
import '../providers/language_models_provider.dart';

class LanguageModelsPage extends ConsumerStatefulWidget {
  const LanguageModelsPage({super.key, this.initialSetup = false});

  final bool initialSetup;

  @override
  ConsumerState<LanguageModelsPage> createState() => _LanguageModelsPageState();
}

class _LanguageModelsPageState extends ConsumerState<LanguageModelsPage> {
  String _sourceLanguage = 'en';
  String _targetLanguage = 'es';
  bool _finishingSetup = false;
  bool _loadingPreferences = false;
  String? _setupError;

  @override
  void initState() {
    super.initState();
    if (!widget.initialSetup) {
      _loadCurrentLanguages();
    }
  }

  Future<void> _loadCurrentLanguages() async {
    setState(() => _loadingPreferences = true);
    await ref.read(settingsProvider.notifier).loadSettings();
    if (!mounted) return;

    final settingsState = ref.read(settingsProvider);
    final settings = settingsState.settings;
    if (settings == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(settingsState.error ?? 'Could not load settings.'),
        ),
      );
    } else {
      setState(() {
        _sourceLanguage = settings.defaultSourceLanguage == 'auto'
            ? 'en'
            : settings.defaultSourceLanguage;
        _targetLanguage = settings.defaultTargetLanguage;
      });
    }
    if (mounted) setState(() => _loadingPreferences = false);
  }

  Future<void> _downloadPreferredModels() async {
    if (_sourceLanguage == _targetLanguage) {
      setState(() => _setupError = 'Choose two different languages.');
      return;
    }

    setState(() {
      _finishingSetup = true;
      _setupError = null;
    });

    final success = await ref
        .read(languageModelsProvider.notifier)
        .downloadMany([_sourceLanguage, _targetLanguage]);
    if (!mounted) return;

    if (!success) {
      setState(() {
        _finishingSetup = false;
        _setupError = 'One or more models could not be downloaded. Try again.';
      });
      return;
    }

    await _completeSetup();
  }

  Future<void> _completeSetup() async {
    if (_sourceLanguage == _targetLanguage) {
      setState(() {
        _finishingSetup = false;
        _setupError = 'Choose two different languages.';
      });
      return;
    }

    final settingsResult = await di.sl<GetSettingsUseCase>()(NoParams());
    if (!mounted) return;

    final settings = settingsResult.fold((Failure failure) {
      setState(() {
        _finishingSetup = false;
        _setupError = failure.message;
      });
      return null;
    }, (settings) => settings);
    if (settings == null) return;

    final updateResult = await di.sl<UpdateSettingsUseCase>()(
      settings.copyWith(
        defaultSourceLanguage: _sourceLanguage,
        defaultTargetLanguage: _targetLanguage,
        enableAutoDetect: false,
      ),
    );
    if (!mounted) return;

    final updateFailure = updateResult.fold<Failure?>(
      (failure) => failure,
      (_) => null,
    );
    if (updateFailure != null) {
      setState(() {
        _finishingSetup = false;
        _setupError = updateFailure.message;
      });
      return;
    }

    final result = await di.sl<CompleteFirstLaunchUseCase>()(NoParams());
    if (!mounted) return;

    result.fold((Failure failure) {
      setState(() {
        _finishingSetup = false;
        _setupError = failure.message;
      });
    }, (_) => context.go(RouteNames.camera));
  }

  Future<void> _skipSetup() async {
    setState(() => _finishingSetup = true);
    await _completeSetup();
  }

  Future<void> _saveLanguagePreferences() async {
    if (_sourceLanguage == _targetLanguage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose two different languages.')),
      );
      return;
    }

    setState(() => _finishingSetup = true);
    final downloaded = await ref
        .read(languageModelsProvider.notifier)
        .downloadMany([_sourceLanguage, _targetLanguage]);
    if (!mounted) return;

    if (!downloaded) {
      setState(() => _finishingSetup = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not download the selected models.'),
        ),
      );
      return;
    }

    final settingsResult = await di.sl<GetSettingsUseCase>()(NoParams());
    if (!mounted) return;
    final settings = settingsResult.fold((failure) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message)));
      return null;
    }, (settings) => settings);
    if (settings == null) {
      setState(() => _finishingSetup = false);
      return;
    }

    final updateResult = await di.sl<UpdateSettingsUseCase>()(
      settings.copyWith(
        defaultSourceLanguage: _sourceLanguage,
        defaultTargetLanguage: _targetLanguage,
        enableAutoDetect: false,
      ),
    );
    if (!mounted) return;

    updateResult.fold(
      (failure) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
        setState(() => _finishingSetup = false);
      },
      (_) {
        ref.read(settingsProvider.notifier).loadSettings().then((_) {
          if (!mounted) return;
          setState(() => _finishingSetup = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Translation languages updated.')),
          );
        });
      },
    );
  }

  Future<void> _deleteModel(String code) async {
    final settings = ref.read(settingsProvider).settings;
    if (settings != null &&
        (settings.defaultTargetLanguage == code ||
            (!settings.enableAutoDetect &&
                settings.defaultSourceLanguage == code))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Change your translation languages before removing this model.',
          ),
        ),
      );
      return;
    }

    final success = await ref
        .read(languageModelsProvider.notifier)
        .delete(code);
    if (!mounted || success) return;
    final error = ref.read(languageModelsProvider).error;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error ?? 'Could not remove this language model.')),
    );
  }

  Widget _languageDropdown({
    required String label,
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      isExpanded: true,
      items: SupportedLanguages.all
          .map(
            (language) => DropdownMenuItem(
              value: language.code,
              child: Text('${language.name} (${language.nativeName})'),
            ),
          )
          .toList(),
      onChanged: _finishingSetup ? null : onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(languageModelsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialSetup ? 'Choose your languages' : 'Language models',
        ),
        leading: widget.initialSetup ? null : const BackButton(),
        actions: [
          if (!widget.initialSetup)
            IconButton(
              tooltip: 'Refresh model status',
              onPressed: state.isLoading
                  ? null
                  : () => ref.read(languageModelsProvider.notifier).refresh(),
              icon: const Icon(Icons.refresh),
            ),
        ],
      ),
      body: state.isLoading || _loadingPreferences
          ? const Center(child: CircularProgressIndicator())
          : widget.initialSetup
          ? _buildInitialSetup()
          : _buildModelList(state),
    );
  }

  Widget _buildInitialSetup() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Icon(Icons.translate, size: 56),
        const SizedBox(height: 16),
        Text(
          'Download language models',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose the languages you use most. Their models are downloaded once '
          'and let translations run on your device. An internet connection is '
          'needed for the download.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        _languageDropdown(
          label: 'Translate from',
          value: _sourceLanguage,
          onChanged: (value) {
            if (value != null) setState(() => _sourceLanguage = value);
          },
        ),
        const SizedBox(height: 16),
        _languageDropdown(
          label: 'Translate to',
          value: _targetLanguage,
          onChanged: (value) {
            if (value != null) setState(() => _targetLanguage = value);
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Selected models: ${SupportedLanguages.displayName(_sourceLanguage)} '
          'and ${SupportedLanguages.displayName(_targetLanguage)}',
          textAlign: TextAlign.center,
        ),
        if (_sourceLanguage == _targetLanguage) ...[
          const SizedBox(height: 8),
          Text(
            'Choose different source and target languages.',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          ),
        ],
        if (_setupError != null) ...[
          const SizedBox(height: 12),
          Text(
            _setupError!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _finishingSetup || _sourceLanguage == _targetLanguage
              ? null
              : _downloadPreferredModels,
          icon: _finishingSetup
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.download),
          label: Text(
            _finishingSetup ? 'Preparing models…' : 'Download and continue',
          ),
        ),
        TextButton(
          onPressed: _finishingSetup ? null : _skipSetup,
          child: const Text('Do this later'),
        ),
      ],
    );
  }

  Widget _buildModelList(LanguageModelsState state) {
    if (state.error != null && state.downloaded.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(state.error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () =>
                    ref.read(languageModelsProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Translation languages',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              _languageDropdown(
                label: 'Translate from',
                value: _sourceLanguage,
                onChanged: (value) {
                  if (value != null) setState(() => _sourceLanguage = value);
                },
              ),
              const SizedBox(height: 12),
              _languageDropdown(
                label: 'Translate to',
                value: _targetLanguage,
                onChanged: (value) {
                  if (value != null) setState(() => _targetLanguage = value);
                },
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _finishingSetup ? null : _saveLanguagePreferences,
                icon: _finishingSetup
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.download),
                label: Text(
                  _finishingSetup
                      ? 'Preparing models…'
                      : 'Save and download selected models',
                ),
              ),
              const Divider(height: 32),
              Text(
                'Available offline models',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        ...SupportedLanguages.all.map((language) {
          final downloaded = state.isDownloaded(language.code);
          final downloading = state.isDownloading(language.code);

          return ListTile(
            title: Text(language.name),
            subtitle: Text(
              state.itemErrors[language.code] ?? language.nativeName,
              style: state.itemErrors.containsKey(language.code)
                  ? TextStyle(color: Theme.of(context).colorScheme.error)
                  : null,
            ),
            trailing: downloading
                ? const SizedBox.square(
                    dimension: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : downloaded
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      IconButton(
                        tooltip: 'Remove ${language.name} model',
                        onPressed: () => _deleteModel(language.code),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  )
                : TextButton.icon(
                    onPressed: () => ref
                        .read(languageModelsProvider.notifier)
                        .download(language.code),
                    icon: const Icon(Icons.download),
                    label: const Text('Download'),
                  ),
          );
        }),
      ],
    );
  }
}
