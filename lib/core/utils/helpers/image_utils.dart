import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class ImageUtils {
  /// Compresses image to reduce size while maintaining quality
  static Future<Uint8List> compressImage(
    Uint8List imageBytes, {
    int maxSize = 1024 * 1024, // 1MB default
    int quality = 85,
  }) async {
    try {
      // If image is already small enough, return as is
      if (imageBytes.length <= maxSize) {
        return imageBytes;
      }
      
      // Decode the image
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        return imageBytes;
      }
      
      // Calculate compression ratio needed
      final ratio = (maxSize / imageBytes.length).clamp(0.1, 1.0);
      final newWidth = (image.width * math.sqrt(ratio)).round();
      final newHeight = (image.height * math.sqrt(ratio)).round();
      
      // Resize the image
      final resized = img.copyResize(
        image,
        width: newWidth,
        height: newHeight,
        interpolation: img.Interpolation.linear,
      );
      
      // Encode with compression
      final compressed = img.encodeJpg(resized, quality: quality);
      
      // If still too large, reduce quality further
      if (compressed.length > maxSize) {
        int adjustedQuality = quality;
        Uint8List result = compressed;
        
        while (result.length > maxSize && adjustedQuality > 20) {
          adjustedQuality -= 10;
          result = img.encodeJpg(resized, quality: adjustedQuality);
        }
        
        return result;
      }
      
      return compressed;
    } catch (e) {
      // If compression fails, return original
      return imageBytes;
    }
  }
  
  /// Converts bytes to Flutter Image
  static Future<ui.Image> bytesToImage(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }
  
  /// Checks if image quality is sufficient for text recognition
  static bool isImageQualitySufficient(Uint8List imageBytes) {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) return false;
      
      // Minimum dimensions for good text recognition
      const minWidth = 640;
      const minHeight = 480;
      
      return image.width >= minWidth && image.height >= minHeight;
    } catch (e) {
      return false;
    }
  }
  
  /// Gets image dimensions
  static Future<Size?> getImageDimensions(Uint8List imageBytes) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) return null;
      
      return Size(image.width.toDouble(), image.height.toDouble());
    } catch (e) {
      return null;
    }
  }
}

class Size {
  final double width;
  final double height;
  
  Size(this.width, this.height);
}


