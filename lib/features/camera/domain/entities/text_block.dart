class TextBlock {
  final String text;
  final BoundingBox boundingBox;
  final double confidence;
  
  TextBlock({
    required this.text,
    required this.boundingBox,
    required this.confidence,
  });
}

class BoundingBox {
  final double left;
  final double top;
  final double width;
  final double height;
  
  BoundingBox({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });
}


