import '../entities/receipt_test.dart';

/// Use case: Validate that a receipt has usable items.
class ValidateReceiptUseCase {
  const ValidateReceiptUseCase();

  bool call(Receipt receipt) {
    if (receipt.items.isEmpty) return false;
    if (!receipt.isValid()) return false;
    if (receipt.selectedItems.isEmpty) return false;
    return true;
  }
}
