import 'package:flutter/material.dart';

class TranslationLoading extends StatelessWidget {
  const TranslationLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}


