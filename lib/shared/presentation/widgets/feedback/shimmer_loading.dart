import 'package:flutter/material.dart';

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  
  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    this.height = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}


