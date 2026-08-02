part of 'calculator_bloc.dart';

abstract class CalculatorState extends Equatable {
  const CalculatorState();

  @override
  List<Object?> get props => [];
}

class CalculatorInitial extends CalculatorState {
  const CalculatorInitial();
}

class CalculatorLoaded extends CalculatorState {
  final Receipt receipt;
  final Money selectedTotal;
  final bool isValid;

  const CalculatorLoaded({
    required this.receipt,
    required this.selectedTotal,
    required this.isValid,
  });

  @override
  List<Object?> get props => [receipt, selectedTotal, isValid];
}

class CalculatorFailure extends CalculatorState {
  final String error;

  const CalculatorFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
