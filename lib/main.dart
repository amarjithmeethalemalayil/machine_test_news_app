import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:machine_test_news_app/core/theme/app_theme.dart';
import 'package:machine_test_news_app/core/services/api_service.dart';
import 'package:machine_test_news_app/features/domain/usecase/fetch_news_usecase.dart';
import 'package:machine_test_news_app/features/presentation/provider/news_provider.dart';
import 'package:machine_test_news_app/features/presentation/pages/home_page.dart';
import 'features/data/datasource/news_remote_data_source.dart';
import 'features/data/repository/news_repository_impl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MachineTestNewsApp());
}

class MachineTestNewsApp extends StatelessWidget {
  const MachineTestNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final String baseUrl = dotenv.env['BASE_URL'] ?? '';
    final String apiKey = dotenv.env['API_KEY'] ?? '';

    return ChangeNotifierProvider(
      create: (context) {
        final apiService = ApiService(
          client: http.Client(),
          baseUrl: baseUrl,
          apiKey: apiKey,
        );
        final remoteDataSource = NewsRemoteDataSourceImpl(
          apiService: apiService,
        );
        final newsRepo = NewsRepoImpl(remoteDataSource: remoteDataSource);
        final fetchNewsUseCase = FetchNewsUseCase(newsRepo: newsRepo);
        return NewsProvider(newsUseCase: fetchNewsUseCase);
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        home: const HomePage(),
      ),
    );
  }
}
