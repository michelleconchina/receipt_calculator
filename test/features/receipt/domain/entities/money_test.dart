import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_calculator/features/receipt/domain/entities/money.dart';

void main() {
  group('Money', () {
    test('add() combines two amounts', () {
      final money1 = const Money(amount: 100, currency: 'PHP');
      final money2 = const Money(amount: 50, currency: 'PHP');

      final result = money1.add(money2);

      expect(result.amount, 150);
      expect(result.currency, 'PHP');
    });

    test('add() throws on currency mismatch', () {
      final money1 = const Money(amount: 100, currency: 'PHP');
      final money2 = const Money(amount: 50, currency: 'USD');

      expect(
        () => money1.add(money2),
        throwsA(isA<CurrencyMismatchException>()),
      );
    });

    test('round() fixes floating-point errors', () {
      final money = const Money(amount: 99.999, currency: 'PHP');

      final result = money.round();

      expect(result.amount, 100.00);
    });

    test('equality works correctly', () {
      final money1 = const Money(amount: 100, currency: 'PHP');
      final money2 = const Money(amount: 100, currency: 'PHP');

      expect(money1, money2);
    });
  });
}
