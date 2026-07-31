import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_calculator/core/constants/app_dimension.dart';

import '../../../../core/constants/route_paths.dart';

/// Preview screen shown after an image is selected.
class ImagePreviewScreen extends StatelessWidget {
  const ImagePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close_rounded),
        ),
      ),
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
                    AppDimension.borderRadiusNormal,
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
              onPressed: () => context.push(kPreviewRoute),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                side: BorderSide(color: colorScheme.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimension.borderRadiusNormal,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_rounded,
                    size: AppDimension.iconSizeSmall,
                    color: colorScheme.primary,
                  ),
                  // const SizedBox(width: 12),
                  const SizedBox(width: AppDimension.spaceMedium),
                  Text(
                    'Retake',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimension.spaceSmall),
            FilledButton(
              onPressed: () => context.push(kReceiptReviewRoute),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimension.borderRadiusNormal,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_rounded,
                    size: AppDimension.iconSizeSmall,
                    color: colorScheme.onPrimary,
                  ),
                  const SizedBox(width: AppDimension.spaceMedium),
                  Text(
                    'Continue',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimension.spaceLarge),
          ],
        ),
      ),
    );
  }
}
