import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_calculator/features/upload/presentation/bloc/upload_bloc.dart';

import '../../../../core/constants/route_paths.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      colorScheme.primary.withValues(alpha: .08),
                      colorScheme.primary.withValues(alpha: 0.03),
                    ],
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 48,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Receipt\nCalculator',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        color: colorScheme.primary,
                      ),
                    ),

                    // Subtitle
                    Text(
                      'Scan any receipt and calculate your total in seconds.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.6,
                      ),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 24),

                    // Illustration placeholder (receipt + calculator)
                    _HeroIllustration(colorScheme: colorScheme),
                  ],
                ),
              ),

              // Main content
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    // Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        Icons.receipt_long_rounded,
                        size: 44,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Headline
                    Text(
                      'Scan a receipt',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),

                    // Supporting text
                    Text(
                      'Take a photo or choose from your gallery to extract items and calculate the total.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // ✅ CAMERA BUTTON — Now triggers UploadBloc
                    BlocListener<UploadBloc, UploadState>(
                      listener: (context, state) {
                        if (state is UploadSuccess) {
                          context.push(kPreviewRoute);
                        } else if (state is UploadFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${state.error}')),
                          );
                        }
                      },
                      child: FilledButton(
                        onPressed: () {
                          // ✅ Trigger camera capture via UploadBloc
                          context.read<UploadBloc>().add(
                            const CaptureFromCameraEvent(),
                          );
                        },
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          backgroundColor: colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_rounded,
                              size: 20,
                              color: colorScheme.onPrimary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Take Photo',
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ✅ GALLERY BUTTON — Now triggers UploadBloc
                    BlocListener<UploadBloc, UploadState>(
                      listener: (context, state) {
                        if (state is UploadSuccess) {
                          context.push(kPreviewRoute);
                        } else if (state is UploadFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${state.error}')),
                          );
                        }
                      },
                      child: OutlinedButton(
                        onPressed: () {
                          // ✅ Trigger gallery pick via UploadBloc
                          context.read<UploadBloc>().add(
                            const PickFromGalleryEvent(),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          side: BorderSide(
                            color: colorScheme.primary,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_rounded,
                              size: 20,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Choose from Gallery',
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Hero illustration area (receipt + calculator)
class _HeroIllustration extends StatelessWidget {
  final ColorScheme colorScheme;

  const _HeroIllustration({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Decorative background circle
        Positioned(
          right: -40,
          top: -20,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withValues(alpha: 0.05),
            ),
          ),
        ),

        // Receipt card
        Transform.rotate(
          angle: -0.1,
          child: Container(
            margin: const EdgeInsets.only(right: 40, bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Receipt header
                const Text(
                  'SUPERMARKET',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),

                // Items
                ...[
                  ('Coke', '45.00'),
                  ('Bread', '72.00'),
                  ('Shampoo', '189.00'),
                ].map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.$1,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          item.$2,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 8),
                Container(height: 0.5, color: Colors.grey.shade300),
                const SizedBox(height: 8),

                // Total
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOTAL',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '306.00',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Calculator icon
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: .4),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: const Icon(
              Icons.calculate_rounded,
              size: 48,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
