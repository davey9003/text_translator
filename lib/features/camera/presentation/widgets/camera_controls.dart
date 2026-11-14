import 'package:flutter/material.dart';

class CameraControls extends StatelessWidget {
  final VoidCallback onCapture;
  final VoidCallback onFlip;
  final VoidCallback onGallery;
  
  const CameraControls({
    super.key,
    required this.onCapture,
    required this.onFlip,
    required this.onGallery,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.photo_library),
          onPressed: onGallery,
          tooltip: 'Open Gallery',
        ),
        ElevatedButton(
          onPressed: onCapture,
          child: const Text('Capture'),
        ),
        IconButton(
          icon: const Icon(Icons.flip_camera_ios),
          onPressed: onFlip,
          tooltip: 'Flip Camera',
        ),
      ],
    );
  }
}


