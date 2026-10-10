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

    test('clearItems removes all items', () {
      final receipt = Receipt(
        sourceImagePath: '/test.jpg',
        items: [item1, item2],
      );

      final cleared = receipt.clearItems();

      expect(cleared.items, isEmpty);
      expect(cleared.selectedTotal.amount, 0);
      expect(cleared.id, receipt.id);
    });

    group('service charge', () {
      final selected1 = item1;
      final selected2 = item2.copyWith(isSelected: true);

      test('adds a proportional share to selectedTotal', () {
        final receipt = Receipt(
          sourceImagePath: '/test.jpg',
          items: [item1, item2],
          serviceCharge: const Money(amount: 14.5),
        );

        expect(receipt.selectedItemsSubtotal.amount, 45);
        expect(receipt.selectedServiceCharge.amount, 4.5); // 14.5 × 45/145
        expect(receipt.selectedTotal.amount, 49.5);
      });

      test('adds the full charge when all items are selected', () {
        final receipt = Receipt(
          sourceImagePath: '/test.jpg',
          items: [selected1, selected2],
          serviceCharge: const Money(amount: 14.5),
        );

        expect(receipt.selectedTotal.amount, 159.5);
      });

      test('does not add VAT to selectedTotal', () {
        final receipt = Receipt(
          sourceImagePath: '/test.jpg',
          items: [selected1, selected2],
          vatAmount: const Money(amount: 15.54),
        );

        expect(receipt.selectedTotal.amount, 145);
      });

      test('is zero when nothing is selected or items are cleared', () {
        final receipt = Receipt(
          sourceImagePath: '/test.jpg',
          items: [item1.toggle(), item2],
          serviceCharge: const Money(amount: 14.5),
        );

        expect(receipt.selectedTotal.amount, 0);
        expect(receipt.clearItems().selectedTotal.amount, 0);
        expect(receipt.clearItems().serviceCharge.amount, 14.5);
      });
    });
  });
}
