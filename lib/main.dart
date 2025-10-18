import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:machine_test_news_app/injection_container.dart';
import 'package:machine_test_news_app/machine_test_news_app.dart';
import 'package:provider/provider.dart';
import 'package:machine_test_news_app/features/presentation/provider/news_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  final String apiKey = dotenv.env['API_KEY'] ?? '';
  await initDI(baseUrl: baseUrl, apiKey: apiKey);
  runApp(
    ChangeNotifierProvider(
      create: (context) => sl<NewsProvider>(),
      child: const MachineTestNewsApp(),
    ),
  );
}
