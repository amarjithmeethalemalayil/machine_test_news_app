
import '../../domain/repository/news_repository.dart';
import '../datasource/news_remote_data_source.dart';
import '../model/article_model.dart';

class NewsRepoImpl implements NewsRepo {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepoImpl({required this.remoteDataSource});

  @override
  Future<List<ArticleModel>> fetchNewsArticles({
    required int page,
    required int pageSize,
  }) async {
    final articles = await remoteDataSource.fetchArticles(page: page);
    return articles;
  }
}
