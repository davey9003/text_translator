import 'package:flutter/material.dart';

class LanguageSwapButton extends StatelessWidget {
  final VoidCallback onSwap;
  
  const LanguageSwapButton({
    super.key,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.swap_horiz),
      onPressed: onSwap,
      tooltip: 'Swap languages',
    );
  }
}


