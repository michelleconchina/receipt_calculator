import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_calculator/features/receipt/presentation/screens/scanning_screen.dart';
import 'package:receipt_calculator/features/upload/presentation/screens/gallery_screen.dart';

import '../../features/calculator/presentation/screens/receipt_review_screen.dart';
import '../../features/receipt/presentation/screens/ocr_loading_screen.dart';
import '../../features/upload/presentation/screens/home_screen.dart';
import '../../features/upload/presentation/screens/image_preview_screen.dart';
import '../constants/route_paths.dart';

/// Creates the application [GoRouter] with the MVP navigation flow:
/// Home → Preview → OCR Loading → Receipt Review.
GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: kHomeRoute,
    routes: [
      GoRoute(
        path: kHomeRoute,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: kPreviewRoute,
        name: 'preview',
        builder: (context, state) => const ImagePreviewScreen(),
      ),
      GoRoute(
        path: kReceiptGalleryRoute,
        name: 'gallery',
        builder: (context, state) => const GalleryScreen(),
      ),
      GoRoute(
        path: kOcrLoadingRoute,
        name: 'ocr-loading',
        builder: (context, state) => const OcrLoadingScreen(),
      ),
      GoRoute(
        path: kReceiptReviewRoute,
        name: 'receipt-review',
        builder: (context, state) => const ReceiptReviewScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(
        child: Text(state.error?.toString() ?? 'Unknown routing error'),
      ),
    ),
  );
}
