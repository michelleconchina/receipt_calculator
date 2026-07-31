import 'package:equatable/equatable.dart';
import 'package:receipt_calculator/features/receipt/domain/entities/money.dart';
import 'package:uuid/uuid.dart';

/// Represents a single line item from a receipt.
class ReceiptItem extends Equatable {
  final String id;
  final String description;
  final int quantity;
  final Money unitPrice;
  final Money totalPrice;
  final bool isSelected; // User can deselect items

  ReceiptItem({
    String? id,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.isSelected = true,
  }) : id = id ?? Uuid().v4();

  /// Creates a copy with optional field overrides.
  ReceiptItem copyWith({
    String? id,
    String? description,
    int? quantity,
    Money? unitPrice,
    Money? totalPrice,
    bool? isSelected,
  }) {
    return ReceiptItem(
      id: id ?? this.id,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  /// Toggles selection state.
  ReceiptItem toggle() => copyWith(isSelected: !isSelected);

  /// Validates that quantity and prices make sense.
  bool isValid() {
    if (quantity <= 0) return false;
    if (unitPrice.amount <= 0) return false;
    if (totalPrice.amount <= 0) return false;

    // Check that total ≈ quantity × unitPrice (allow 1% rounding error)
    final expected = unitPrice.amount * quantity;
    final diff = (totalPrice.amount - expected).abs();
    return diff <= expected * 0.01;
  }

  @override
  List<Object?> get props => [
    id,
    description,
    quantity,
    unitPrice,
    totalPrice,
    isSelected,
  ];
}
