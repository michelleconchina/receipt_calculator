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
  const CalculatorLoaded({
    required this.receipt,
    required this.selectedTotal,
    required this.isValid,
  });

  final Receipt receipt;
  final Money selectedTotal;
  final bool isValid;

  @override
  List<Object?> get props => [receipt, selectedTotal, isValid];
}

class CalculatorFailure extends CalculatorState {
  const CalculatorFailure({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}
