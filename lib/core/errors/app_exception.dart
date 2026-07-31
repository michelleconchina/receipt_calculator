import 'package:equatable/equatable.dart';

/// Base class for typed application failures.
sealed class AppException extends Equatable implements Exception {
  const AppException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  List<Object?> get props => [message, cause];

  @override
  String toString() => message;
}

/// Image could not be obtained from camera or gallery.
final class ImageInputException extends AppException {
  const ImageInputException(super.message, {super.cause});
}

/// Camera or gallery permission was denied.
final class PermissionDeniedException extends AppException {
  const PermissionDeniedException(super.message, {super.cause});
}

/// OCR text extraction failed.
final class OcrException extends AppException {
  const OcrException(super.message, {super.cause});
}

/// Receipt text could not be parsed into purchasable items.
final class ReceiptParseException extends AppException {
  const ReceiptParseException(super.message, {super.cause});
}

/// No image was selected when one was required.
final class NoImageSelectedException extends AppException {
  const NoImageSelectedException(super.message, {super.cause});
}
