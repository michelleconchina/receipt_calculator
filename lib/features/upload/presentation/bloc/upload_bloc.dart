import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:receipt_calculator/features/receipt/data/services/image_service.dart';

part 'upload_event.dart';
part 'upload_state.dart';

/// BLoC for handling image upload (camera/gallery).
class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final ImageService _imageService;

  UploadBloc({required ImageService imageService})
    : _imageService = imageService,
      super(const UploadInitial()) {
    on<CaptureFromCameraEvent>(_onCaptureFromCamera);
    on<PickFromGalleryEvent>(_onPickFromGallery);
    on<CompressImageEvent>(_onCompressImage);
    on<ResetUploadEvent>(_onResetUpload);
  }

  /// Capture image from camera.
  Future<void> _onCaptureFromCamera(
    CaptureFromCameraEvent event,
    Emitter<UploadState> emit,
  ) async {
    emit(const UploadLoading());
    try {
      final image = await _imageService.captureFromCamera();
      if (image == null) {
        emit(const UploadInitial());
        return;
      }
      emit(UploadSuccess(imagePath: image.path));
    } catch (e) {
      emit(UploadFailure(error: e.toString()));
    }
  }

  /// Pick image from gallery.
  Future<void> _onPickFromGallery(
    PickFromGalleryEvent event,
    Emitter<UploadState> emit,
  ) async {
    emit(const UploadLoading());
    try {
      final image = await _imageService.pickFromGallery();
      if (image == null) {
        emit(const UploadInitial());
        return;
      }
      emit(UploadSuccess(imagePath: image.path));
    } catch (e) {
      emit(UploadFailure(error: e.toString()));
    }
  }

  /// Compress image.
  Future<void> _onCompressImage(
    CompressImageEvent event,
    Emitter<UploadState> emit,
  ) async {
    emit(const UploadLoading());
    try {
      final compressedPath = await _imageService.compressImage(event.imagePath);
      emit(UploadSuccess(imagePath: compressedPath));
    } catch (e) {
      emit(UploadFailure(error: e.toString()));
    }
  }

  /// Reset to initial state.
  Future<void> _onResetUpload(
    ResetUploadEvent event,
    Emitter<UploadState> emit,
  ) async {
    emit(const UploadInitial());
  }
}
