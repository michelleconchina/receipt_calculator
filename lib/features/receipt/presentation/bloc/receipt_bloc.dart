import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/receipt.dart';
import '../../domain/usecases/parse_receipt_usecase.dart';

part 'receipt_event.dart';
part 'receipt_state.dart';

/// BLoC for OCR and receipt parsing.
class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  final ParseReceiptUseCase _parseReceiptUseCase;

  ReceiptBloc({required ParseReceiptUseCase parseReceiptUseCase})
    : _parseReceiptUseCase = parseReceiptUseCase,
      super(const ReceiptInitial()) {
    on<ParseReceiptEvent>(_onParseReceipt);
    on<ResetReceiptEvent>(_onResetReceipt);
  }

  /// Parse receipt from image.
  Future<void> _onParseReceipt(
    ParseReceiptEvent event,
    Emitter<ReceiptState> emit,
  ) async {
    emit(const ReceiptLoading());
    try {
      final receipt = await _parseReceiptUseCase(imagePath: event.imagePath);
      emit(ReceiptSuccess(receipt: receipt));
    } catch (e) {
      emit(ReceiptFailure(error: e.toString()));
    }
  }

  /// Reset to initial state.
  Future<void> _onResetReceipt(
    ResetReceiptEvent event,
    Emitter<ReceiptState> emit,
  ) async {
    emit(const ReceiptInitial());
  }
}
