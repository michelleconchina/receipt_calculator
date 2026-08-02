import 'package:receipt_calculator/features/receipt/domain/entities/receipt.dart';

abstract class ReceiptParserInterface {
  /// Takes raw OCR text and returns a parsed Receipt.
  /// Throws ParseException if parsing fails.
  Future<Receipt> parseReceipt({
    required String rawText,
    required String sourceImagePath,
  });
}
