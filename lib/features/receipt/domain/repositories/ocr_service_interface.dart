/// Contract for any OCR service (ML Kit, Tesseract, etc.)
abstract class OCRServiceInterface {
  /// Extracts text from an image path.
  /// Returns raw text with coordinates (future enhancement).
  Future<String> extractText(String imagePath);
}
