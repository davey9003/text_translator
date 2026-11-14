import 'package:flutter/material.dart';

class FocusIndicator extends StatelessWidget {
  final Offset position;
  
  const FocusIndicator({
    super.key,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx - 50,
      top: position.dy - 50,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}


