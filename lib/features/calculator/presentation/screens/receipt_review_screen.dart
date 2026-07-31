import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_calculator/core/constants/app_dimension.dart';

import '../../../../core/constants/route_paths.dart';

/// Placeholder receipt review screen for the routing shell.
class ReceiptReviewScreen extends StatelessWidget {
  const ReceiptReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Review Items')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Checkbox(value: true, onChanged: null),
            title: Text('Sample Item'),
            trailing: Text(r'$4.99'),
          ),
          ListTile(
            leading: Checkbox(value: false, onChanged: null),
            title: Text('Another Item'),
            trailing: Text(r'$2.50'),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimension.paddingS),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selected total',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(r'$4.99', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              const SizedBox(height: AppDimension.spaceMedium),
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
            ],
          ),
        ),
      ),
    );
  }
}
