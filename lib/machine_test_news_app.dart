import 'package:flutter/material.dart';
import 'package:machine_test_news_app/core/constants/route/app_router.dart';
import 'package:machine_test_news_app/core/theme/app_theme.dart';
import 'package:machine_test_news_app/features/presentation/pages/home_page.dart';

class MachineTestNewsApp extends StatelessWidget {
  const MachineTestNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      onGenerateRoute: AppRouter.onGenerateRoute,
      home: const HomePage(),
    );
  }
}
