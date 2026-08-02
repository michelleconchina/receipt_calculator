import '../../domain/entities/money.dart';
import '../../domain/entities/receipt.dart';
import '../../domain/entities/receipt_item.dart';
import '../repositories/receipt_parser_interface.dart';
import '../../domain/utils/receipt_business_rules.dart';

/// Regex-based receipt parser.
class RegexReceiptParser implements ReceiptParserInterface {
  @override
  Future<Receipt> parseReceipt({
    required String rawText,
    required String sourceImagePath,
  }) async {
    var lines = rawText
        .split('\n')
        .map((line) => line.replaceAll('{', '').replaceAll('}', '').trim())
        .where((line) => line.isNotEmpty)
        .toList();

    final items = <ReceiptItem>[];

    // Look for lines starting with "1 " or "2 " etc (quantity indicator)
    final qtyPattern = RegExp(r'^(\d+)\s+(.+)$');

    // Look for prices like "P204.00" or "39.00"
    final pricePattern = RegExp(r'P?([\d,]+\.\d{2})');

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Skip obvious junk
      if (ReceiptBusinessRules.shouldIgnoreLine(line)) continue;
      if (line.length < 3) continue;
      if (line.contains(RegExp(r'^\d{10,}'))) continue; // Barcode

      // Match "1 HILKY CHEESE ROLLTET"
      final qtyMatch = qtyPattern.firstMatch(line);
      if (qtyMatch == null) continue;

      final quantity = int.tryParse(qtyMatch.group(1)!) ?? 1;
      var itemName = qtyMatch.group(2)!;

      // Look ahead for price in next 5 lines
      double? price;
      for (var j = i + 1; j < lines.length && j < i + 5; j++) {
        final priceMatch = pricePattern.firstMatch(lines[j]);
        if (priceMatch != null) {
          final priceStr = priceMatch.group(1)!.replaceAll(',', '');
          price = double.tryParse(priceStr);
          if (price != null && price > 0) {
            break;
          }
        }
      }

      // If we found a price, create item
      if (price != null && price > 0) {
        final item = ReceiptItem(
          description: itemName.trim(),
          quantity: quantity,
          unitPrice: Money(amount: price),
          totalPrice: Money(amount: price * quantity),
        );

        if (item.isValid()) {
          print('✅ $itemName = P$price');
          items.add(item);
        }
      }
    }

    print('=== TOTAL ITEMS: ${items.length} ===');

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
