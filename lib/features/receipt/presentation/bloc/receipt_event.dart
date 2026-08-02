part of 'receipt_bloc.dart';

abstract class ReceiptEvent extends Equatable {
  const ReceiptEvent();

  @override
  List<Object?> get props => [];
}

class ParseReceiptEvent extends ReceiptEvent {
  final String imagePath;

  const ParseReceiptEvent({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

class ResetReceiptEvent extends ReceiptEvent {
  const ResetReceiptEvent();
}
