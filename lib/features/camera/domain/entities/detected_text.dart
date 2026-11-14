import 'text_block.dart';

class DetectedText {
  final String fullText;
  final List<TextBlock> blocks;
  final DateTime detectedAt;
  
  DetectedText({
    required this.fullText,
    required this.blocks,
    required this.detectedAt,
  });
}


