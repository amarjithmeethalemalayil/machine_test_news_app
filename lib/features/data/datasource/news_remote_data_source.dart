import 'package:machine_test_news_app/core/services/api_service.dart';
import 'package:machine_test_news_app/features/data/model/article_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<ArticleModel>> fetchArticles({int page});
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final ApiService apiService;

  NewsRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<ArticleModel>> fetchArticles({int page = 1}) async {
    try {
      final jsonMap = await apiService.get(
        '',
        queryParams: {
          'country': 'us',
          'pageSize': '20',
          'page': page.toString(),
        },
      );

      final articlesJson = jsonMap['articles'] as List<dynamic>?;

      if (articlesJson == null || articlesJson.isEmpty) {
        return [];
      }
      return articlesJson
          .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch articles: $e');
    }
  }
}
