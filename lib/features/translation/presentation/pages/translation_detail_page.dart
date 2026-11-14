import 'package:flutter/material.dart';

class TranslationDetailPage extends StatefulWidget {
  const TranslationDetailPage({super.key});

  @override
  State<TranslationDetailPage> createState() => _TranslationDetailPageState();
}

class _TranslationDetailPageState extends State<TranslationDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translation Detail'),
      ),
      body: const Center(
        child: Text('Translation Detail Page'),
      ),
    );
  }
}


