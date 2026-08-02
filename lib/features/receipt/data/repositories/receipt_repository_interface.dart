import 'package:receipt_calculator/features/receipt/domain/entities/receipt.dart';

/// Contract for Receipt data storage (local or cloud).
abstract class ReceiptRepositoryInterface {
  /// Saves a receipt locally.
  Future<void> save(Receipt receipt);

  /// Retrieves a receipt by ID.
  Future<Receipt?> getById(String id);

  /// Retrieves all receipts.
  Future<List<Receipt>> getAll();

  /// Deletes a receipt.
  Future<void> delete(String id);
}
