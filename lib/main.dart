import 'package:flutter/material.dart';
import 'package:machine_test_news_app/core/theme/app_theme.dart';

import 'features/presentation/pages/home_page.dart';

void main() {
  runApp(const MachineTestNewsApp());
}

class MachineTestNewsApp extends StatelessWidget {
  const MachineTestNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      home: HomePage(),
    );
  }
}
