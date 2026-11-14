import '../../domain/entities/detected_text.dart';
import '../../domain/entities/text_block.dart';

class DetectedTextModel extends DetectedText {
  DetectedTextModel({
    required super.fullText,
    required super.blocks,
    required super.detectedAt,
  });
  
  factory DetectedTextModel.fromJson(Map<String, dynamic> json) {
    return DetectedTextModel(
      fullText: json['fullText'] as String,
      blocks: (json['blocks'] as List)
          .map((block) => TextBlock(
                text: block['text'] as String,
                boundingBox: BoundingBox(
                  left: (block['boundingBox']['left'] as num).toDouble(),
                  top: (block['boundingBox']['top'] as num).toDouble(),
                  width: (block['boundingBox']['width'] as num).toDouble(),
                  height: (block['boundingBox']['height'] as num).toDouble(),
                ),
                confidence: (block['confidence'] as num).toDouble(),
              ))
          .toList(),
      detectedAt: DateTime.parse(json['detectedAt'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'fullText': fullText,
      'blocks': blocks.map((block) => {
        'text': block.text,
        'boundingBox': {
          'left': block.boundingBox.left,
          'top': block.boundingBox.top,
          'width': block.boundingBox.width,
          'height': block.boundingBox.height,
        },
        'confidence': block.confidence,
      }).toList(),
      'detectedAt': detectedAt.toIso8601String(),
    };
  }
}


