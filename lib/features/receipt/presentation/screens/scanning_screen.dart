import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/di/injection.dart';
import '../../../calculator/presentation/bloc/calculator_bloc.dart';
import '../bloc/receipt_bloc.dart';

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({super.key});

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> {
  @override
  void initState() {
    super.initState();
    // Listen for receipt parsing completion
    context.read<ReceiptBloc>().stream.listen((state) {
      if (state is ReceiptSuccess) {
        // Load into calculator
        getIt<CalculatorBloc>().add(LoadReceiptEvent(receipt: state.receipt));
        context.push(kReceiptReviewRoute);
      } else if (state is ReceiptFailure) {
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            const Text('Extracting items...'),
          ],
        ),
      ),
    );
  }
}
