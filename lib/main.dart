import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:machine_test_news_app/injection_container.dart';
import 'package:machine_test_news_app/machine_test_news_app.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test_news_app/features/presentation/bloc/news_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  final String apiKey = dotenv.env['API_KEY'] ?? '';
  await initDI(baseUrl: baseUrl, apiKey: apiKey);

  runApp(
    BlocProvider<NewsBloc>(
      create: (context) => sl<NewsBloc>(),
      child: const MachineTestNewsApp(),
    ),
  );
}
