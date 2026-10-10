import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:receipt_calculator/features/receipt/data/repositories/ocr_service_interface.dart';

/// OCR using Google ML Kit with image preprocessing.
class MLKitOCRService implements OCRServiceInterface {
  late final TextRecognizer _recognizer;

  MLKitOCRService() {
    _recognizer = TextRecognizer(script: TextRecognitionScript.latin);
  }

  @override
  Future<String> extractText(String imagePath) async {
    try {
      print('🔍 Starting ML Kit OCR with preprocessing...');

      // Step 1: Compress image for better OCR
      print('📦 Compressing image...');
      final compressedPath = await _compressImage(imagePath);

      print('✅ Image compressed: $compressedPath');
      print('🔍 Running OCR...');

      // Step 2: Run OCR on compressed image
      final inputImage = InputImage.fromFilePath(compressedPath);
      final recognizedText = await _recognizer.processImage(inputImage);

      // Step 3: Extract text blocks
      final textLines = <String>[];
      for (final block in recognizedText.blocks) {
        for (final line in block.lines) {
          textLines.add(line.text);
        }
      }

      final text = textLines.join('\n');

      print('✅ OCR Complete. Text length: ${text.length}');
      print('=== RAW OCR TEXT ===');
      print(text);
      print('=== END RAW TEXT ===');

      return text;
    } catch (e) {
      print('❌ OCR failed: $e');
      throw OCRException('ML Kit extraction failed: $e');
    }
  }

  /// Compress & enhance image for better OCR accuracy.
  Future<String> _compressImage(String imagePath) async {
    try {
      final compressed = await FlutterImageCompress.compressAndGetFile(
        imagePath,
        imagePath
            .replaceAll('.jpg', '_compressed.jpg')
            .replaceAll('.heic', '_compressed.jpg'),
        quality: 95, // High quality (better for OCR than 85)
        minHeight: 1280, // Larger dimensions help OCR
        minWidth: 1280,
      );

      if (compressed == null) {
        print('⚠️ Compression returned null, using original');
        return imagePath;
      }

      print(
        '✅ Compressed from ${imagePath.split('/').last} to ${compressed.path.split('/').last}',
      );
      return compressed.path;
    } catch (e) {
      print('⚠️ Compression failed: $e, using original image');
      return imagePath;
    }
  }

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
