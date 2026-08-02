/// Static class containing business rules for receipt parsing.
abstract final class ReceiptBusinessRules {
  /// More ignore keywords for receipts
  static const List<String> ignoreKeywords = [
    'TOTAL',
    'SUBTOTAL',
    'SUB-TOTAL',
    'TAX',
    'VAT',
    'SERVICE CHARGE',
    'TIP',
    'CHANGE',
    'TENDERED',
    'DATE',
    'TIME',
    'RECEIPT NO',
    'TRANSACTION ID',
    'STORE',
    'ADDRESS',
    'PHONE',
    'INVOICE',
    'DISCOUNT',
    'AMOUNT DUE',
    'CASHIER',
    'BUYER',
    'NAME OF CUSTOMER',
    'COMPANY',
    'CARD NO',
    'APPROVAL CODE',
    'CREDIT',
    'VAT Sale',
    'VAT Exempt',
    'VAT Zero Rated',
  ];

  /// Checks if a line should be ignored based on keywords.
  static bool shouldIgnoreLine(String line) {
    final upperLine = line.toUpperCase();
    return ignoreKeywords.any((keyword) => upperLine.contains(keyword));
  }

  /// Extracts price from a line (rightmost number).
  /// E.g., "Bread 45.00" → 45.00
  static double? extractPrice(String line) {
    final regex = RegExp(r'(\d+\.?\d*)');
    final matches = regex.allMatches(line);
    if (matches.isEmpty) return null;
    final lastMatch = matches.last;
    return double.tryParse(lastMatch.group(0)!);
  }

  /// Extracts quantity from a line (leftmost number or default 1).
  static int extractQuantity(String line) {
    final regex = RegExp(r'(\d+)');
    final match = regex.firstMatch(line);
    if (match != null) {
      final qty = int.tryParse(match.group(0)!);
      if (qty != null && qty > 0 && qty < 100) {
        // Reasonable quantity
        return qty;
      }
    }
    return 1; // Default quantity
  }
}
