import '../entities/money.dart';
import '../entities/receipt.dart';

/// Use case: Calculate the total of selected items in a receipt.
class CalculateReceiptTotalUseCase {
  const CalculateReceiptTotalUseCase();

  Money call(Receipt receipt) {
    return receipt.selectedTotal;
  }
}
