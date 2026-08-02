import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../calculator/presentation/bloc/calculator_bloc.dart';
import '../bloc/receipt_bloc.dart';

/// Loading screen displayed during OCR text extraction.
class OcrLoadingScreen extends StatefulWidget {
  const OcrLoadingScreen({super.key});

  @override
  State<OcrLoadingScreen> createState() => _OcrLoadingScreenState();
}

class _OcrLoadingScreenState extends State<OcrLoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Listen to ReceiptBloc for completion
    _listenToReceiptParsing();
  }

  void _listenToReceiptParsing() {
    context.read<ReceiptBloc>().stream.listen((state) {
      if (!mounted) return;

      if (state is ReceiptSuccess) {
        // Load into calculator and navigate
        getIt<CalculatorBloc>().add(LoadReceiptEvent(receipt: state.receipt));
        context.go(kReceiptReviewRoute);
      } else if (state is ReceiptFailure) {
        // Show error
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.error)));
        context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanning Receipt')),
      body: BlocBuilder<ReceiptBloc, ReceiptState>(
        builder: (context, state) {
          String message = 'Reading receipt…';

          if (state is ReceiptLoading) {
            message = 'Extracting items…';
          } else if (state is ReceiptFailure) {
            message = 'Error: ${state.error}';
          }

          return AppLoadingIndicator(message: message);
        },
      ),
    );
  }
}
