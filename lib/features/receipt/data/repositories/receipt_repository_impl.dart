import 'package:receipt_calculator/features/receipt/domain/entities/receipt.dart';
import '../repositories/receipt_repository_interface.dart';

/// In-memory receipt repository.
class InMemoryReceiptRepository implements ReceiptRepositoryInterface {
  final Map<String, Receipt> _storage = {};

  @override
  Future<void> save(Receipt receipt) async {
    _storage[receipt.id] = receipt;
  }

  @override
  Future<Receipt?> getById(String id) async {
    return _storage[id];
  }

  @override
  Future<List<Receipt>> getAll() async {
    return _storage.values.toList();
  }

  @override
  Future<void> delete(String id) async {
    _storage.remove(id);
  }
}
