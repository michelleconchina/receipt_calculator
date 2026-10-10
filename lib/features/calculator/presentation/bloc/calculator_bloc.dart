import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:receipt_calculator/features/receipt/domain/entities/money.dart';

import '../../../receipt/domain/entities/receipt.dart';
import '../../../receipt/domain/usecases/calculate_receipt_total_usecase.dart';
import '../../../receipt/domain/usecases/validate_receipt_usecase.dart';

part 'calculator_event.dart';
part 'calculator_state.dart';

/// BLoC for item selection and total calculation.
class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  CalculatorBloc({
    required CalculateReceiptTotalUseCase calculateTotal,
    required ValidateReceiptUseCase validateReceipt,
  }) : _calculateTotal = calculateTotal,
       _validateReceipt = validateReceipt,
       super(const CalculatorInitial()) {
    on<LoadReceiptEvent>(_onLoadReceipt);
    on<ToggleItemEvent>(_onToggleItem);
    on<RemoveItemEvent>(_onRemoveItem);
    on<ClearAllItemsEvent>(_onClearAllItems);
  }

  final CalculateReceiptTotalUseCase _calculateTotal;
  final ValidateReceiptUseCase _validateReceipt;

  /// Load receipt into calculator.
  Future<void> _onLoadReceipt(
    LoadReceiptEvent event,
    Emitter<CalculatorState> emit,
  ) async {
    try {
      final isValid = _validateReceipt(event.receipt);
      final total = _calculateTotal(event.receipt);

      emit(
        CalculatorLoaded(
          receipt: event.receipt,
          selectedTotal: total,
          isValid: isValid,
        ),
      );
    } catch (e) {
      emit(CalculatorFailure(error: e.toString()));
    }
  }

  /// Toggle item selection.
  Future<void> _onToggleItem(
    ToggleItemEvent event,
    Emitter<CalculatorState> emit,
  ) async {
    if (state is! CalculatorLoaded) return;

    final currentState = state as CalculatorLoaded;
    final updatedReceipt = currentState.receipt.toggleItem(event.itemId);
    final total = _calculateTotal(updatedReceipt);

    emit(
      CalculatorLoaded(
        receipt: updatedReceipt,
        selectedTotal: total,
        isValid: _validateReceipt(updatedReceipt),
      ),
    );
  }

  /// Remove item from receipt.
  Future<void> _onRemoveItem(
    RemoveItemEvent event,
    Emitter<CalculatorState> emit,
  ) async {
    if (state is! CalculatorLoaded) return;

    final currentState = state as CalculatorLoaded;
    final updatedReceipt = currentState.receipt.removeItem(event.itemId);
    final total = _calculateTotal(updatedReceipt);

    emit(
      CalculatorLoaded(
        receipt: updatedReceipt,
        selectedTotal: total,
        isValid: _validateReceipt(updatedReceipt),
      ),
    );
  }

  /// Remove all items from receipt.
  Future<void> _onClearAllItems(
    ClearAllItemsEvent event,
    Emitter<CalculatorState> emit,
  ) async {
    if (state is! CalculatorLoaded) return;

    final currentState = state as CalculatorLoaded;
    final updatedReceipt = currentState.receipt.clearItems();
    final total = _calculateTotal(updatedReceipt);

    emit(
      CalculatorLoaded(
        receipt: updatedReceipt,
        selectedTotal: total,
        isValid: _validateReceipt(updatedReceipt),
      ),
    );
  }
}
