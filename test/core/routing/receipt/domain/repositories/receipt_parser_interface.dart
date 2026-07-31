import '../entities/receipt_test.dart';

/// Contract for any receipt parser (Regex, AI, etc.)
abstract class ReceiptParserInterface {
  /// Takes raw OCR text and returns a parsed Receipt.
  /// Throws ParseException if parsing fails.
  Future<Receipt> parseReceipt({
    required String rawText,
    required String sourceImagePath,
  });
}
