import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_calculator/features/receipt/domain/usecases/calculate_receipt_total_usecase.dart';
import 'package:receipt_calculator/features/receipt/domain/usecases/validate_receipt_usecase.dart';

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

  // Router
  getIt.registerLazySingleton<GoRouter>(createAppRouter);

  // Domain Use Cases (Pure logic, no dependencies yet)
  getIt.registerLazySingleton(() => const ValidateReceiptUseCase());
  getIt.registerLazySingleton(() => const CalculateReceiptTotalUseCase());

  // ParseReceiptUseCase (needs OCRService + Parser — register later in Phase 3)
  // For now, skip it. We'll add it when Phase 3 integrates ML Kit.
}
