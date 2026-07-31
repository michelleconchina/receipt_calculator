import 'package:equatable/equatable.dart';

/// Value object representing currency amount.
/// Immutable, with equality and hashCode built in.
class Money extends Equatable {
  final double amount;
  final String currency;

  const Money({
    required this.amount,
    this.currency = 'PHP', // Default currency
  });

  /// Adds two Money objects (same currency required).
  Money add(Money other) {
    if (currency != other.currency) {
      throw CurrencyMismatchException(
        'Cannot add $currency and ${other.currency}',
      );
    }
    return Money(amount: amount + other.amount, currency: currency);
  }

  /// Subtracts two Money objects.
  Money subtract(Money other) {
    if (currency != other.currency) {
      throw CurrencyMismatchException(
        'Cannot subtract $currency and ${other.currency}',
      );
    }
    return Money(amount: amount - other.amount, currency: currency);
  }

  /// Checks if this Money is zero.
  bool get isZero => amount == 0;

  /// Rounds to 2 decimal places.
  Money round() {
    return Money(
      amount: double.parse(amount.toStringAsFixed(2)),
      currency: currency,
    );
  }

  @override
  List<Object?> get props => [amount, currency];

  @override
  String toString() => '$currency $amount';
}

class CurrencyMismatchException implements Exception {
  final String message;
  CurrencyMismatchException(this.message);

  @override
  String toString() => message;
}
