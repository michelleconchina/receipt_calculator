import 'package:receipt_calculator/features/receipt/domain/entities/receipt.dart';
import 'package:receipt_calculator/features/receipt/domain/repositories/ocr_service_interface.dart';
import 'package:receipt_calculator/features/receipt/domain/repositories/receipt_parser_interface.dart';

/// Use case: Extract text from image → Parse into Receipt.
class ParseReceiptUseCase {
  final OCRServiceInterface ocrService;
  final ReceiptParserInterface parser;

  ParseReceiptUseCase({required this.ocrService, required this.parser});

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

    return receipt;
  }
}

class InvalidReceiptException implements Exception {
  final String message;
  InvalidReceiptException(this.message);

  @override
  String toString() => message;
}
