import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';

/// Placeholder receipt review screen for the routing shell.
class ReceiptReviewScreen extends StatelessWidget {
  const ReceiptReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Items'),
      ),
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
          padding: const EdgeInsets.all(16),
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
                  Text(
                    r'$4.99',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go(kHomeRoute),
                child: const Text('Start Over'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
