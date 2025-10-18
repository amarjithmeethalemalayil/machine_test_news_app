import 'package:machine_test_news_app/features/domain/entity/article_entity.dart';

abstract interface class NewsRepo {
  Future<List<Article>> fetchNewsArticles({
    required int page,
    required int pageSize,
  });
}
