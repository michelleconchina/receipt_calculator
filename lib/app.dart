import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/constants/app_constants.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'features/calculator/presentation/bloc/calculator_bloc.dart';
import 'features/receipt/presentation/bloc/receipt_bloc.dart';
import 'features/upload/presentation/bloc/upload_bloc.dart';

class ReceiptCalculatorApp extends StatelessWidget {
  const ReceiptCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<GoRouter>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<UploadBloc>.value(value: getIt<UploadBloc>()),
        BlocProvider<ReceiptBloc>.value(value: getIt<ReceiptBloc>()),
        BlocProvider<CalculatorBloc>.value(value: getIt<CalculatorBloc>()),
      ],
      child: MaterialApp.router(
        title: kAppName,
        theme: AppTheme.light,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
