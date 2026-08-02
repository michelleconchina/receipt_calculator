import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_calculator/features/receipt/domain/usecases/calculate_receipt_total_usecase.dart';
import 'package:receipt_calculator/features/receipt/domain/usecases/validate_receipt_usecase.dart';
import 'package:receipt_calculator/features/receipt/presentation/bloc/receipt_bloc.dart';
import 'package:receipt_calculator/features/upload/presentation/bloc/upload_bloc.dart';
import '../../features/receipt/data/repositories/ocr_service_interface.dart';
import '../../features/receipt/data/repositories/receipt_parser_interface.dart';
import '../../features/receipt/data/repositories/receipt_repository_interface.dart';
import '../../features/receipt/data/services/regex_parser.dart';
import '../../features/receipt/data/repositories/receipt_repository_impl.dart';
import '../../features/receipt/domain/usecases/parse_receipt_usecase.dart';
import '../../features/receipt/data/services/image_service.dart';
import '../../features/receipt/data/services/ml_kit_ocr_service.dart';
import 'package:receipt_calculator/features/calculator/presentation/bloc/calculator_bloc.dart';
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

  // In configureDependencies():
  getIt.registerLazySingleton<ImageService>(() => ImageService());
  getIt.registerLazySingleton<OCRServiceInterface>(() => MLKitOCRService());
  getIt.registerLazySingleton<ReceiptParserInterface>(
    () => RegexReceiptParser(),
  );
  getIt.registerLazySingleton<ReceiptRepositoryInterface>(
    () => InMemoryReceiptRepository(),
  );
  getIt.registerLazySingleton(
    () => ParseReceiptUseCase(
      ocrService: getIt<OCRServiceInterface>(),
      parser: getIt<ReceiptParserInterface>(),
    ),
  );
  // BLoCs
  getIt.registerSingleton<UploadBloc>(
    UploadBloc(imageService: getIt<ImageService>()),
  );
  getIt.registerSingleton<ReceiptBloc>(
    ReceiptBloc(parseReceiptUseCase: getIt<ParseReceiptUseCase>()),
  );
  getIt.registerSingleton<CalculatorBloc>(
    CalculatorBloc(
      calculateTotal: getIt<CalculateReceiptTotalUseCase>(),
      validateReceipt: getIt<ValidateReceiptUseCase>(),
    ),
  );
}
