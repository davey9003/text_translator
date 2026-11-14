import 'package:flutter/material.dart';

class TranslationHistoryPage extends StatefulWidget {
  const TranslationHistoryPage({super.key});

  @override
  State<TranslationHistoryPage> createState() => _TranslationHistoryPageState();
}

class _TranslationHistoryPageState extends State<TranslationHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translation History'),
      ),
      body: const Center(
        child: Text('Translation History Page'),
      ),
    );
  }
}


