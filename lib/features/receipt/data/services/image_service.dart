import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

/// Service to handle image capture and processing.
class ImageService {
  final ImagePicker _picker = ImagePicker();

  /// Capture image from camera.
  Future<File?> captureFromCamera() async {
    try {
      final photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo == null) return null;
      return File(photo.path);
    } catch (e) {
      throw ImageCaptureException('Failed to capture image: $e');
    }
  }

  /// Pick image from gallery.
  Future<File?> pickFromGallery() async {
    try {
      final photo = await _picker.pickImage(source: ImageSource.gallery);
      if (photo == null) return null;
      return File(photo.path);
    } catch (e) {
      throw ImagePickException('Failed to pick image: $e');
    }
  }

  /// Compress image to reduce file size (50-70% reduction).
  Future<String> compressImage(String imagePath) async {
    try {
      final compressed = await FlutterImageCompress.compressAndGetFile(
        imagePath,
        imagePath.replaceAll('.jpg', '_compressed.jpg'),
        quality: 85,
        minHeight: 1024,
        minWidth: 1024,
      );

      if (compressed == null) {
        throw ImageCompressionException('Compression returned null');
      }

      return compressed.path;
    } catch (e) {
      throw ImageCompressionException('Failed to compress image: $e');
    }
  }
}

class ImageCaptureException implements Exception {
  ImageCaptureException(this.message);
  final String message;
  @override
  String toString() => message;
}

class ImagePickException implements Exception {
  ImagePickException(this.message);
  final String message;
  @override
  String toString() => message;
}

class ImageCompressionException implements Exception {
  ImageCompressionException(this.message);
  final String message;
  @override
  String toString() => message;
}
