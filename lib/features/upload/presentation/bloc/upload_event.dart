part of 'upload_bloc.dart';

abstract class UploadEvent extends Equatable {
  const UploadEvent();

  @override
  List<Object?> get props => [];
}

class CaptureFromCameraEvent extends UploadEvent {
  const CaptureFromCameraEvent();
}

class PickFromGalleryEvent extends UploadEvent {
  const PickFromGalleryEvent();
}

class CompressImageEvent extends UploadEvent {
  final String imagePath;

  const CompressImageEvent({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

class ResetUploadEvent extends UploadEvent {
  const ResetUploadEvent();
}
