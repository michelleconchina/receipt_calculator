import 'dart:io';

abstract class OCRService {
  /// Processes an image file and returns extracted raw text block strings.
  Future<List<String>> processImage(File imageFile);
}
