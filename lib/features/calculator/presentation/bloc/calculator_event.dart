part of 'calculator_bloc.dart';

abstract class CalculatorEvent extends Equatable {
  const CalculatorEvent();

  @override
  List<Object?> get props => [];
}

class LoadReceiptEvent extends CalculatorEvent {
  const LoadReceiptEvent({required this.receipt});

  final Receipt receipt;

  @override
  List<Object?> get props => [receipt];
}

class ToggleItemEvent extends CalculatorEvent {
  const ToggleItemEvent({required this.itemId});

  final String itemId;

  @override
  List<Object?> get props => [itemId];
}

class RemoveItemEvent extends CalculatorEvent {
  const RemoveItemEvent({required this.itemId});

  final String itemId;

  @override
  List<Object?> get props => [itemId];
}

class ClearAllItemsEvent extends CalculatorEvent {
  const ClearAllItemsEvent();
}
