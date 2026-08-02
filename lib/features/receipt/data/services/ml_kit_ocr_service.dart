import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../repositories/ocr_service_interface.dart';

/// OCR implementation using Google ML Kit.
class MLKitOCRService implements OCRServiceInterface {
  late final TextRecognizer _recognizer;

  MLKitOCRService() {
    _recognizer = TextRecognizer(script: TextRecognitionScript.latin);
  }

  /// Extracts text from image path using ML Kit.
  @override
  Future<String> extractText(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await _recognizer.processImage(inputImage);

      // Combine all text blocks into single string
      final text = recognizedText.blocks.map((block) => block.text).join('\n');

      return text;
    } catch (e) {
      throw OCRException('ML Kit extraction failed: $e');
    }
  }

  /// Cleanup resources.
  Future<void> close() async {
    await _recognizer.close();
  }
}

class OCRException implements Exception {
  final String message;
  OCRException(this.message);
  @override
  String toString() => message;
}
