import 'package:flutter/material.dart';
import '../../domain/entities/language.dart';

class LanguageSelector extends StatelessWidget {
  final Language selectedLanguage;
  final List<Language> languages;
  final Function(Language) onLanguageSelected;
  
  const LanguageSelector({
    super.key,
    required this.selectedLanguage,
    required this.languages,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Language>(
      value: selectedLanguage,
      items: languages.map((language) {
        return DropdownMenuItem<Language>(
          value: language,
          child: Text('${language.name} (${language.nativeName})'),
        );
      }).toList(),
      onChanged: (language) {
        if (language != null) {
          onLanguageSelected(language);
        }
      },
    );
  }
}


