import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyShareActions extends StatelessWidget {
  final String text;
  
  const CopyShareActions({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: text));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Copied to clipboard')),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () async {
            // Share functionality using share_plus package
            // Note: Add share_plus to pubspec.yaml if needed
            // For now, copy to clipboard as fallback
            Clipboard.setData(ClipboardData(text: text));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Text copied to clipboard')),
            );
          },
        ),
      ],
    );
  }
}


