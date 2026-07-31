import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_calculator/core/constants/app_dimension.dart';

import '../../../../core/constants/route_paths.dart';

/// Preview screen shown after an image is selected.
class ImagePreviewScreen extends StatelessWidget {
  const ImagePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
      body: Padding(
        padding: const EdgeInsets.all(AppDimension.spaceNormal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(
                    AppDimension.borderRadius,
                  ),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: AppDimension.iconSize,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimension.spaceNormal),
            OutlinedButton(
              onPressed: () => context.go(kHomeRoute),
              child: const Text('Retake'),
            ),
            const SizedBox(height: AppDimension.spaceSmall),
            FilledButton(
              onPressed: () => context.push(kOcrLoadingRoute),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
