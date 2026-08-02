part of 'upload_bloc.dart';

abstract class UploadState extends Equatable {
  const UploadState();

  @override
  List<Object?> get props => [];
}

class UploadInitial extends UploadState {
  const UploadInitial();
}

class UploadLoading extends UploadState {
  const UploadLoading();
}

class UploadSuccess extends UploadState {
  final String imagePath;

  const UploadSuccess({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

class UploadFailure extends UploadState {
  final String error;

  const UploadFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
