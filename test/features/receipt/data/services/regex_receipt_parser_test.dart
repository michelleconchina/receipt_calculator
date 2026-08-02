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
}
