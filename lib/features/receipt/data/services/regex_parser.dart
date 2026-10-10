import 'package:receipt_calculator/features/receipt/data/repositories/receipt_parser_interface.dart';
import 'package:receipt_calculator/features/receipt/domain/entities/money.dart';
import 'package:receipt_calculator/features/receipt/domain/entities/receipt.dart';
import 'package:receipt_calculator/features/receipt/domain/entities/receipt_item.dart';
import 'package:receipt_calculator/features/receipt/domain/utils/receipt_business_rules.dart';

class RegexReceiptParser implements ReceiptParserInterface {
  @override
  Future<Receipt> parseReceipt({
    required String rawText,
    required String sourceImagePath,
  }) async {
    // Clean text
    var lines = rawText
        .split('\n')
        .map((line) => line.replaceAll('{', '').replaceAll('}', '').trim())
        .where((line) => line.isNotEmpty)
        .toList();

    print('=== PARSING ${lines.length} LINES ===');

    final items = <ReceiptItem>[];

    // Find where items end (SUBTOTAL line)
    int subtotalIndex = lines.length;
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].toUpperCase().contains('SUBTOTAL') ||
          lines[i].toUpperCase().contains('SUB TOTAL')) {
        subtotalIndex = i;
        print('🔍 Found SUBTOTAL at line $i');
        break;
      }
    }

    // Extract item lines (quantity + name: "1 ITEM NAME")
    final itemLines = <String>[];
    for (var i = 0; i < subtotalIndex; i++) {
      final line = lines[i];

      if (line.length < 3) continue;
      if (ReceiptBusinessRules.shouldIgnoreLine(line)) continue;

      // Match pattern: "1 ITEM" or "2 ITEM" etc
      if (RegExp(r'^\d+\s+[A-Za-z]').hasMatch(line)) {
        itemLines.add(line);
        print('✅ Item: $line');
      }
    }

    // Extract prices (AFTER subtotal)
    final priceLines = <double>[];
    final priceRegex = RegExp(r'P?([\d.]+)\s*$');

    for (var i = subtotalIndex + 1; i < lines.length; i++) {
      final line = lines[i];

      // Skip long/metadata lines
      if (line.length > 40) continue;
      if (ReceiptBusinessRules.shouldIgnoreLine(line)) continue;

      final match = priceRegex.firstMatch(line);
      if (match != null) {
        final price = double.tryParse(match.group(1)!);

        // Valid price range: P0.01 to P100,000
        if (price != null && price > 0 && price < 100000) {
          priceLines.add(price);
          print('💰 Price: P$price');
        }
      }
    }

    print('📊 ${itemLines.length} items, ${priceLines.length} prices');

    // Match items with prices (1-to-1)
    for (var i = 0; i < itemLines.length && i < priceLines.length; i++) {
      final itemLine = itemLines[i];
      final price = priceLines[i];

      final match = RegExp(r'^(\d+)\s+(.+)$').firstMatch(itemLine);
      if (match != null) {
        final qty = int.tryParse(match.group(1)!) ?? 1;
        final name = match.group(2)!.trim();

        final item = ReceiptItem(
          description: name,
          quantity: qty,
          unitPrice: Money(amount: price),
          totalPrice: Money(amount: price * qty),
        );

        print('✅ CREATED: $qty x "$name" = P$price');
        items.add(item);
      }
    }

    print('=== EXTRACTED ${items.length} ITEMS ===\n');

    final receipt = Receipt(
      sourceImagePath: sourceImagePath,
      items: items,
      ocrConfidence: _calculateConfidence(items.length),
    );

    return receipt;
  }

  double _calculateConfidence(int itemCount) {
    if (itemCount == 0) return 0.0;
    if (itemCount < 3) return 0.5;
    if (itemCount < 10) return 0.8;
    return 0.9;
  }
}
