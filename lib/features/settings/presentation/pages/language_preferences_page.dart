import 'package:flutter/material.dart';

class LanguagePreferencesPage extends StatefulWidget {
  const LanguagePreferencesPage({super.key});

  @override
  State<LanguagePreferencesPage> createState() => _LanguagePreferencesPageState();
}

class _LanguagePreferencesPageState extends State<LanguagePreferencesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Preferences'),
      ),
      body: const Center(
        child: Text('Language Preferences Page'),
      ),
    );
  }
}


