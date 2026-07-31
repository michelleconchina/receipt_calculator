import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../routing/app_router.dart';

final GetIt getIt = GetIt.instance;

/// Registers core services and feature dependencies.
///
/// Feature-specific registrations are added in later milestones as
/// repositories, use cases, and blocs are implemented.
Future<void> configureDependencies() async {
  if (getIt.isRegistered<GoRouter>()) {
    return;
  }

  getIt.registerLazySingleton<GoRouter>(createAppRouter);
}
