import 'package:flutter/material.dart';
import '../../../../features/translation/domain/entities/language.dart';

class LanguagePickerDialog extends StatelessWidget {
  final List<Language> languages;
  final Language? selectedLanguage;
  final Function(Language) onLanguageSelected;
  
  const LanguagePickerDialog({
    super.key,
    required this.languages,
    this.selectedLanguage,
    required this.onLanguageSelected,
  });

  static Future<Language?> show(
    BuildContext context, {
    required List<Language> languages,
    Language? selectedLanguage,
  }) {
    return showDialog<Language>(
      context: context,
      builder: (context) => LanguagePickerDialog(
        languages: languages,
        selectedLanguage: selectedLanguage,
        onLanguageSelected: (language) {
          Navigator.of(context).pop(language);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Language'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: languages.length,
          itemBuilder: (context, index) {
            final language = languages[index];
            final isSelected = selectedLanguage?.code == language.code;
            return ListTile(
              title: Text(language.name),
              subtitle: Text(language.nativeName),
              trailing: isSelected ? const Icon(Icons.check) : null,
              onTap: () => onLanguageSelected(language),
            );
          },
        ),
      ),
    );
  }
}

