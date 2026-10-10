import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_calculator/features/receipt/data/services/regex_parser.dart';

void main() {
  late RegexReceiptParser parser;

  setUp(() {
    parser = RegexReceiptParser();
  });

  group('RegexReceiptParser', () {
    test('parses simple receipt', () async {
      final rawText = '''
        SUPERMARKET
        Coke 45.00
        Bread 72.00
        Shampoo 189.00
        TOTAL 306.00
      ''';

      final receipt = await parser.parseReceipt(
        rawText: rawText,
        sourceImagePath: '/test.jpg',
      );

      expect(receipt.items.length, 3);
      expect(receipt.items[0].description, contains('Coke'));
    });

    test('ignores TOTAL lines', () async {
      final rawText = '''
        Item1 50.00
        TOTAL 50.00
      ''';

      final receipt = await parser.parseReceipt(
        rawText: rawText,
        sourceImagePath: '/test.jpg',
      );

      expect(receipt.items.length, 1);
    });
  });

  group('RegexReceiptParser service charge and VAT', () {
    test('reads amounts on the same line as their labels', () async {
      const rawText = '''
1 Sisig
2 Iced Tea
SUBTOTAL 370.00
250.00
60.00
SERVICE CHARGE 10%  37.00
VAT AMOUNT 39.64
TOTAL 407.00
''';

      final receipt = await parser.parseReceipt(
        rawText: rawText,
        sourceImagePath: '/test.jpg',
      );

      expect(receipt.items.length, 2);
      expect(receipt.items[0].unitPrice.amount, 250);
      expect(receipt.items[1].unitPrice.amount, 60);
      expect(receipt.serviceCharge.amount, 37);
      expect(receipt.vatAmount.amount, 39.64);
    });

    test('reads amounts split onto the next line', () async {
      const rawText = '''
1 Sisig
1 Halo Halo
SUBTOTAL 400.00
SERVICE CHARGE
40.00
250.00
150.00
VAT AMOUNT
42.86
TOTAL 440.00
''';

      final receipt = await parser.parseReceipt(
        rawText: rawText,
        sourceImagePath: '/test.jpg',
      );

      // The charge amount line is not zipped onto the first item
      expect(receipt.items.map((i) => i.unitPrice.amount), [250, 150]);
      expect(receipt.serviceCharge.amount, 40);
      expect(receipt.vatAmount.amount, 42.86);
    });

    test('defaults to zero when the receipt has no charges', () async {
      const rawText = '''
1 Sisig
SUBTOTAL 250.00
250.00
TOTAL 250.00
''';

      final receipt = await parser.parseReceipt(
        rawText: rawText,
        sourceImagePath: '/test.jpg',
      );

      expect(receipt.serviceCharge.isZero, true);
      expect(receipt.vatAmount.isZero, true);
    });
  });
}
