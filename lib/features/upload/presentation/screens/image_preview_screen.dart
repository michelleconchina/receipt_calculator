import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/di/injection.dart';
import '../../../receipt/presentation/bloc/receipt_bloc.dart';
import '../bloc/upload_bloc.dart';

class ImagePreviewScreen extends StatelessWidget {
  const ImagePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadBloc, UploadState>(
      listener: (context, state) {
        if (state is UploadSuccess) {
          // Trigger OCR
          getIt<ReceiptBloc>().add(
            ParseReceiptEvent(imagePath: state.imagePath),
          );
          context.push(kOcrLoadingRoute);
        } else if (state is UploadFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Preview Receipt')),
        body: BlocBuilder<UploadBloc, UploadState>(
          builder: (context, state) {
            if (state is UploadSuccess) {
              return Column(
                children: [
                  Expanded(
                    child: Image.file(File(state.imagePath), fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: FilledButton(
                      onPressed: () {
                        context.read<UploadBloc>().add(
                          CompressImageEvent(imagePath: state.imagePath),
                        );
                      },
                      child: const Text('Scan Receipt'),
                    ),
                  ),
                ],
              );
            }
            return const Center(child: Text('No image selected'));
          },
        ),
      ),
    );
  }
}
