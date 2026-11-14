import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../error/exceptions.dart';

class DetectedTextBlock {
  final String text;
  final MLKitBoundingBox boundingBox;
  final double? confidence;

  DetectedTextBlock({
    required this.text,
    required this.boundingBox,
    this.confidence,
  });
}

class MLKitBoundingBox {
  final double left;
  final double top;
  final double width;
  final double height;

  MLKitBoundingBox({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });
}

abstract class MLKitService {
  Future<List<DetectedTextBlock>> detectText(Uint8List imageBytes);
}

class MLKitServiceImpl implements MLKitService {
  final TextRecognizer _textRecognizer;

  MLKitServiceImpl() : _textRecognizer = TextRecognizer();

  @override
  Future<List<DetectedTextBlock>> detectText(Uint8List imageBytes) async {
    File? tempFile;
    try {
      // Save image bytes to temporary file for ML Kit processing
      final tempDir = await getTemporaryDirectory();
      tempFile = File(
        path.join(
          tempDir.path,
          'text_detection_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      );
      await tempFile.writeAsBytes(imageBytes);

      // Create InputImage from file path (more reliable than fromBytes)
      final inputImage = InputImage.fromFilePath(tempFile.path);

      // Process the image with ML Kit
      final recognizedText = await _textRecognizer.processImage(inputImage);

      // Convert ML Kit results to our DetectedTextBlock format
      final blocks = <DetectedTextBlock>[];

      for (final textBlock in recognizedText.blocks) {
        for (final line in textBlock.lines) {
          // Use line.text instead of element.text for better accuracy
          final lineText = line.text.trim();
          if (lineText.isNotEmpty) {
            blocks.add(
              DetectedTextBlock(
                text: lineText,
                boundingBox: MLKitBoundingBox(
                  left: line.boundingBox.left.toDouble(),
                  top: line.boundingBox.top.toDouble(),
                  width: line.boundingBox.width.toDouble(),
                  height: line.boundingBox.height.toDouble(),
                ),
                confidence: null, // ML Kit doesn't provide confidence scores
              ),
            );
          }
        }
      }

      return blocks;
    } catch (e) {
      throw MLKitException('Failed to detect text: $e');
    } finally {
      // Clean up temporary file
      try {
        await tempFile?.delete();
      } catch (e) {
        // Ignore cleanup errors
      }
    }
  }

  /// Enhanced text detection with quality checks
  Future<List<DetectedTextBlock>> detectTextWithQualityCheck(
    Uint8List imageBytes,
  ) async {
    // Check image quality before processing
    final image = await bytesToImage(imageBytes);
    final dimensions = Size(image.width.toDouble(), image.height.toDouble());

    // Minimum quality requirements
    if (dimensions.width < 640 || dimensions.height < 480) {
      throw MLKitException('Image quality insufficient. Minimum size: 640x480');
    }

    return detectText(imageBytes);
  }

  /// Converts bytes to Flutter Image
  Future<ui.Image> bytesToImage(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  /// Dispose resources when done
  void dispose() {
    _textRecognizer.close();
  }
}
