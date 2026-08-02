part of 'calculator_bloc.dart';

abstract class CalculatorEvent extends Equatable {
  const CalculatorEvent();

  @override
  List<Object?> get props => [];
}

class LoadReceiptEvent extends CalculatorEvent {
  final Receipt receipt;

  const LoadReceiptEvent({required this.receipt});

  @override
  List<Object?> get props => [receipt];
}

class ToggleItemEvent extends CalculatorEvent {
  final String itemId;

  const ToggleItemEvent({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

class RemoveItemEvent extends CalculatorEvent {
  final String itemId;

  const RemoveItemEvent({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}
