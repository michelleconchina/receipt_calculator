import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_calculator/features/receipt/domain/entities/money.dart';
import 'package:receipt_calculator/features/receipt/domain/entities/receipt.dart';
import 'package:receipt_calculator/features/receipt/domain/entities/receipt_item.dart';

void main() {
  group('Receipt', () {
    final item1 = ReceiptItem(
      description: 'Bread',
      quantity: 1,
      unitPrice: const Money(amount: 45),
      totalPrice: const Money(amount: 45),
    );
    final item2 = ReceiptItem(
      description: 'Milk',
      quantity: 2,
      unitPrice: const Money(amount: 50),
      totalPrice: const Money(amount: 100),
      isSelected: false,
    );

    test('selectedTotal ignores deselected items', () {
      final receipt = Receipt(
        sourceImagePath: '/test.jpg',
        items: [item1, item2],
      );

      expect(receipt.selectedTotal.amount, 45); // Only item1
    });

    test('allItemsTotal includes all items', () {
      final receipt = Receipt(
        sourceImagePath: '/test.jpg',
        items: [item1, item2],
      );

      expect(receipt.allItemsTotal.amount, 145); // item1 + item2
    });

    test('toggleItem flips selection', () {
      final receipt = Receipt(
        sourceImagePath: '/test.jpg',
        items: [item1, item2],
      );

      final updated = receipt.toggleItem(item2.id);

      expect(
        updated.items.firstWhere((i) => i.id == item2.id).isSelected,
        true,
      );
    });
  });
}
