import 'package:flutter/material.dart';
import '../../domain/entities/translation.dart';

class TranslatedTextCard extends StatelessWidget {
  final Translation translation;
  
  const TranslatedTextCard({
    super.key,
    required this.translation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translation.originalText,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Divider(),
            Text(
              translation.translatedText,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${translation.sourceLanguage} → ${translation.targetLanguage}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}


