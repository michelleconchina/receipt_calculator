import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import 'money.dart';
import 'receipt_item.dart';

/// Represents a complete receipt with extracted items.
class Receipt extends Equatable {
  final String id;
  final String sourceImagePath; // Where the image came from
  final List<ReceiptItem> items;
  final DateTime scannedAt;
  final String? storeName;
  final double ocrConfidence; // How confident was the OCR?

  Receipt({
    String? id,
    required this.sourceImagePath,
    required this.items,
    DateTime? scannedAt,
    this.storeName,
    this.ocrConfidence = 1.0,
  }) : id = id ?? Uuid().v4(),
       scannedAt = scannedAt ?? DateTime.now();

  /// Gets all selected items.
  List<ReceiptItem> get selectedItems =>
      items.where((item) => item.isSelected).toList();

  /// Calculates the total of all selected items.
  Money get selectedTotal {
    if (selectedItems.isEmpty) {
      return const Money(amount: 0, currency: 'PHP');
    }
    return selectedItems
        .map((item) => item.totalPrice)
        .reduce((a, b) => a.add(b))
        .round();
  }

  /// Calculates the total of all items (regardless of selection).
  Money get allItemsTotal {
    if (items.isEmpty) {
      return const Money(amount: 0, currency: 'PHP');
    }
    return items
        .map((item) => item.totalPrice)
        .reduce((a, b) => a.add(b))
        .round();
  }

  /// Creates a copy with optional field overrides.
  Receipt copyWith({
    String? id,
    String? sourceImagePath,
    List<ReceiptItem>? items,
    DateTime? scannedAt,
    String? storeName,
    double? ocrConfidence,
  }) {
    return Receipt(
      id: id ?? this.id,
      sourceImagePath: sourceImagePath ?? this.sourceImagePath,
      items: items ?? this.items,
      scannedAt: scannedAt ?? this.scannedAt,
      storeName: storeName ?? this.storeName,
      ocrConfidence: ocrConfidence ?? this.ocrConfidence,
    );
  }

  /// Toggles an item's selection by ID.
  Receipt toggleItem(String itemId) {
    return copyWith(
      items: items.map((item) {
        return item.id == itemId ? item.toggle() : item;
      }).toList(),
    );
  }

  /// Removes an item by ID.
  Receipt removeItem(String itemId) {
    return copyWith(items: items.where((item) => item.id != itemId).toList());
  }

  /// Checks if all items are valid.
  bool isValid() => items.isNotEmpty && items.every((item) => item.isValid());

  @override
  List<Object?> get props => [
    id,
    sourceImagePath,
    items,
    scannedAt,
    storeName,
    ocrConfidence,
  ];
}
