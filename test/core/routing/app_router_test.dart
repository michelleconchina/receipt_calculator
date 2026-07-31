import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_calculator/core/constants/route_paths.dart';
import 'package:receipt_calculator/core/routing/app_router.dart';

void main() {
  group('createAppRouter', () {
    late GoRouter router;

    setUp(() {
      router = createAppRouter();
    });

    test('initial location is home', () {
      expect(router.routeInformationProvider.value.uri.path, kHomeRoute);
    });

    test('defines all MVP routes', () {
      final paths = router.configuration.routes
          .whereType<GoRoute>()
          .map((route) => route.path)
          .toList();

      expect(paths, containsAll(<String>[
        kHomeRoute,
        kPreviewRoute,
        kOcrLoadingRoute,
        kReceiptReviewRoute,
      ]));
    });
  });
}
