import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:receipt_calculator/app.dart';
import 'package:receipt_calculator/core/di/injection.dart';
import 'package:receipt_calculator/core/routing/app_router.dart';

void main() {
  setUp(() async {
    await GetIt.instance.reset();
    await configureDependencies();
  });

  testWidgets('app renders home screen', (tester) async {
    await tester.pumpWidget(const ReceiptCalculatorApp());
    await tester.pumpAndSettle();

    expect(find.text('Scan a receipt'), findsOneWidget);
    expect(find.text('Take Photo'), findsOneWidget);
    expect(find.text('Choose from Gallery'), findsOneWidget);
  });

  testWidgets('navigation shell reaches receipt review', (tester) async {
    final router = createAppRouter();
    await tester.pumpWidget(
      MaterialApp.router(routerConfig: router),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Take Photo'));
    await tester.pumpAndSettle();

    expect(find.text('Preview'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Review Items'), findsOneWidget);
    expect(find.text('Sample Item'), findsOneWidget);
  });
}
