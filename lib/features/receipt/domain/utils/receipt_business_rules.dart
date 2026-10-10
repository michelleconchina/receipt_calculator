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

  /// Labels for a service charge line, listed separately from VAT.
  static const List<String> serviceChargeKeywords = [
    'SERVICE CHARGE',
    'SERVICE CHG',
    'SVC CHARGE',
    'SVC CHG',
  ];

  /// Labels for the VAT amount line (12% VAT, already included in prices).
  static const List<String> vatAmountKeywords = [
    'VAT AMOUNT',
    '12% VAT',
    'VAT 12%',
  ];

  /// Finds the amount for the first line (from [start]) containing one of
  /// [keywords]. Reads the trailing amount on the same line, or a bare amount
  /// on the next line when OCR split the label and amount into columns.
  /// Amounts require 2 decimals so rates like "10%" are not read as amounts.
  static ({double amount, int lineIndex})? findLabeledAmount(
    List<String> lines,
    List<String> keywords, {
    int start = 0,
  }) {
    final trailingAmount = RegExp(r'P?([\d,]+\.\d{2})\s*$');
    final bareAmount = RegExp(r'^P?([\d,]+\.\d{2})$');

    for (var i = start; i < lines.length; i++) {
      final upperLine = lines[i].toUpperCase();
      if (!keywords.any(upperLine.contains)) continue;

      final sameLine = trailingAmount.firstMatch(lines[i]);
      if (sameLine != null) {
        final amount = _parseAmount(sameLine.group(1)!);
        if (amount != null) return (amount: amount, lineIndex: i);
      }

      if (i + 1 < lines.length) {
        final nextLine = bareAmount.firstMatch(lines[i + 1].trim());
        if (nextLine != null) {
          final amount = _parseAmount(nextLine.group(1)!);
          if (amount != null) return (amount: amount, lineIndex: i + 1);
        }
      }
      return null;
    }
    return null;
  }

  static double? _parseAmount(String raw) =>
      double.tryParse(raw.replaceAll(',', ''));

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
