import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_calculator/features/calculator/presentation/bloc/calculator_bloc.dart';
import 'package:receipt_calculator/features/receipt/domain/entities/money.dart';
import 'package:receipt_calculator/features/receipt/domain/entities/receipt.dart';
import 'package:receipt_calculator/features/receipt/domain/entities/receipt_item.dart';
import 'package:receipt_calculator/features/receipt/domain/usecases/calculate_receipt_total_usecase.dart';
import 'package:receipt_calculator/features/receipt/domain/usecases/validate_receipt_usecase.dart';

void main() {
  CalculatorBloc buildBloc() => CalculatorBloc(
    calculateTotal: const CalculateReceiptTotalUseCase(),
    validateReceipt: const ValidateReceiptUseCase(),
  );

  final receipt = Receipt(
    sourceImagePath: '/test.jpg',
    items: [
      ReceiptItem(
        description: 'Bread',
        quantity: 1,
        unitPrice: const Money(amount: 45),
        totalPrice: const Money(amount: 45),
      ),
      ReceiptItem(
        description: 'Milk',
        quantity: 2,
        unitPrice: const Money(amount: 50),
        totalPrice: const Money(amount: 100),
      ),
    ],
  );

  group('ClearAllItemsEvent', () {
    blocTest<CalculatorBloc, CalculatorState>(
      'removes all items and resets total to zero',
      build: buildBloc,
      seed: () => CalculatorLoaded(
        receipt: receipt,
        selectedTotal: receipt.selectedTotal,
        isValid: true,
      ),
      act: (bloc) => bloc.add(const ClearAllItemsEvent()),
      expect: () => [
        CalculatorLoaded(
          receipt: receipt.clearItems(),
          selectedTotal: const Money(amount: 0),
          isValid: false,
        ),
      ],
    );

    blocTest<CalculatorBloc, CalculatorState>(
      'does nothing when no receipt is loaded',
      build: buildBloc,
      act: (bloc) => bloc.add(const ClearAllItemsEvent()),
      expect: () => <CalculatorState>[],
    );
  });
}
