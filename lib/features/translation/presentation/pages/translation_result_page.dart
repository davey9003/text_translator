import 'package:flutter/material.dart';

class TranslationResultPage extends StatefulWidget {
  const TranslationResultPage({super.key});

  @override
  State<TranslationResultPage> createState() => _TranslationResultPageState();
}

class _TranslationResultPageState extends State<TranslationResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translation Result'),
      ),
      body: const Center(
        child: Text('Translation Result Page'),
      ),
    );
  }
}


