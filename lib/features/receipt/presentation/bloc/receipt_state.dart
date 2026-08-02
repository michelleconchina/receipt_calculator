part of 'receipt_bloc.dart';

abstract class ReceiptState extends Equatable {
  const ReceiptState();

  @override
  List<Object?> get props => [];
}

class ReceiptInitial extends ReceiptState {
  const ReceiptInitial();
}

class ReceiptLoading extends ReceiptState {
  const ReceiptLoading();
}

class ReceiptSuccess extends ReceiptState {
  final Receipt receipt;

  const ReceiptSuccess({required this.receipt});

  @override
  List<Object?> get props => [receipt];
}

class ReceiptFailure extends ReceiptState {
  final String error;

  const ReceiptFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
