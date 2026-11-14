import 'package:flutter/material.dart';

class SearchBarCustom extends StatelessWidget {
  final String? hint;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  
  const SearchBarCustom({
    super.key,
    this.hint,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint ?? 'Search...',
        prefixIcon: const Icon(Icons.search),
        border: const OutlineInputBorder(),
      ),
    );
  }
}


