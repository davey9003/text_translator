import 'package:flutter/material.dart';
import '../../domain/entities/detected_text.dart';

class TextDetectionOverlay extends StatelessWidget {
  final DetectedText detectedText;
  
  const TextDetectionOverlay({
    super.key,
    required this.detectedText,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TextDetectionPainter(detectedText.blocks),
    );
  }
}

class TextDetectionPainter extends CustomPainter {
  final List<dynamic> blocks;
  
  TextDetectionPainter(this.blocks);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    for (final block in blocks) {
      final box = block.boundingBox;
      final rect = Rect.fromLTWH(
        box.left,
        box.top,
        box.width,
        box.height,
      );
      canvas.drawRect(rect, paint);
    }
  }
  
  @override
  bool shouldRepaint(TextDetectionPainter oldDelegate) {
    return blocks != oldDelegate.blocks;
  }
}


