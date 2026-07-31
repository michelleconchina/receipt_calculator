import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/widgets/app_loading_indicator.dart';

/// Rotating status messages shown while OCR runs.
const List<String> _kOcrStatusMessages = [
  'Reading receipt…',
  'Detecting text…',
  'Extracting line items…',
];

/// Loading screen displayed during OCR text extraction.
class OcrLoadingScreen extends StatefulWidget {
  const OcrLoadingScreen({super.key});

  @override
  State<OcrLoadingScreen> createState() => _OcrLoadingScreenState();
}

class _OcrLoadingScreenState extends State<OcrLoadingScreen> {
  int _messageIndex = 0;

  @override
  void initState() {
    super.initState();
    _startDemoFlow();
  }

  Future<void> _startDemoFlow() async {
    for (var i = 0; i < _kOcrStatusMessages.length; i++) {
      if (!mounted) {
        return;
      }
      setState(() => _messageIndex = i);
      await Future<void>.delayed(const Duration(milliseconds: 900));
    }

    if (!mounted) {
      return;
    }

    await context.push(kReceiptReviewRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanning'),
      ),
      body: AppLoadingIndicator(
        message: _kOcrStatusMessages[_messageIndex],
      ),
    );
  }
}
