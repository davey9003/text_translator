import '../../../../core/services/ml_kit_service.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/detected_text.dart';
import '../../domain/entities/text_block.dart';
import 'dart:typed_data';

abstract class MLKitDataSource {
  Future<DetectedText> detectText(Uint8List imageBytes);
}

class MLKitDataSourceImpl implements MLKitDataSource {
  final MLKitService mlKitService;
  
  MLKitDataSourceImpl(this.mlKitService);
  
  @override
  Future<DetectedText> detectText(Uint8List imageBytes) async {
    try {
      final blocks = await mlKitService.detectText(imageBytes);
      
      final textBlocks = blocks.map((block) => TextBlock(
        text: block.text,
        boundingBox: BoundingBox(
          left: block.boundingBox.left,
          top: block.boundingBox.top,
          width: block.boundingBox.width,
          height: block.boundingBox.height,
        ),
        confidence: 1.0, // ML Kit doesn't always provide confidence
      )).toList();
      
      // Join text blocks with newlines to preserve line structure
      // Then replace multiple newlines with single newline and trim
      final fullText = textBlocks
          .map((block) => block.text)
          .join('\n')
          .replaceAll(RegExp(r'\n+'), '\n')
          .trim();
      
      return DetectedText(
        fullText: fullText,
        blocks: textBlocks,
        detectedAt: DateTime.now(),
      );
    } catch (e) {
      throw MLKitException('Failed to detect text: $e');
    }
  }
}


