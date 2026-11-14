import 'package:flutter/material.dart';
import '../../../translation/domain/entities/language.dart';

class LanguagePreferenceItem extends StatelessWidget {
  final Language language;
  final bool isSelected;
  final VoidCallback onTap;
  
  const LanguagePreferenceItem({
    super.key,
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(language.name),
      subtitle: Text(language.nativeName),
      trailing: isSelected ? const Icon(Icons.check) : null,
      onTap: onTap,
    );
  }
}

