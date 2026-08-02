import '../entities/receipt.dart';
import '../../data/repositories/ocr_service_interface.dart';
import '../../data/repositories/receipt_parser_interface.dart';

/// Use case: Extract text from image → Parse into Receipt.
class ParseReceiptUseCase {
  final OCRServiceInterface ocrService;
  final ReceiptParserInterface parser;

  // Constructor FIRST (before other members)
  const ParseReceiptUseCase({required this.ocrService, required this.parser});

  /// Executes the use case.
  ///
  /// Takes an image path, extracts text via OCR, parses it into a Receipt,
  /// and validates the result.
  ///
  /// Throws [InvalidReceiptException] if the receipt has no valid items.
  Future<Receipt> call({required String imagePath}) async {
    // Step 1: Extract text from image
    final rawText = await ocrService.extractText(imagePath);

    // Step 2: Parse into Receipt
    final receipt = await parser.parseReceipt(
      rawText: rawText,
      sourceImagePath: imagePath,
    );

    // Step 3: Validate
    if (!receipt.isValid()) {
      throw InvalidReceiptException('Receipt has no valid items');
    }

    // Step 4: Return validated receipt
    return receipt;
  }
}

/// Exception thrown when a receipt fails validation.
class InvalidReceiptException implements Exception {
  final String message;

  InvalidReceiptException(this.message);

  @override
  String toString() => message;
}
