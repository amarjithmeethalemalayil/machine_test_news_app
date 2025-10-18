import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:machine_test_news_app/core/services/api_service.dart';
import 'package:machine_test_news_app/features/data/datasource/news_remote_data_source.dart';
import 'package:machine_test_news_app/features/data/repository/news_repository_impl.dart';
import 'package:machine_test_news_app/features/domain/repository/news_repository.dart';
import 'package:machine_test_news_app/features/domain/usecase/fetch_news_usecase.dart';
import 'package:machine_test_news_app/features/presentation/provider/news_provider.dart';

final sl = GetIt.instance;

Future<void> initDI({required String baseUrl, required String apiKey}) async {
  sl.registerLazySingleton<http.Client>(() => http.Client());

  sl.registerLazySingleton<ApiService>(
    () => ApiService(client: sl(), baseUrl: baseUrl, apiKey: apiKey),
  );

  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(apiService: sl()),
  );

  sl.registerLazySingleton<NewsRepo>(
    () => NewsRepoImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<FetchNewsUseCase>(
    () => FetchNewsUseCase(newsRepo: sl()),
  );

  sl.registerFactory<NewsProvider>(() => NewsProvider(newsUseCase: sl()));
}
