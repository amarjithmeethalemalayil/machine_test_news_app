import '../entity/article_entity.dart';
import '../repository/news_repository.dart';

class FetchNewsUseCase {
  final NewsRepo newsRepo;

  FetchNewsUseCase({required this.newsRepo});

  Future<List<Article>> call({
    required int page,
    required int pageSize,
  }) async {
    return await newsRepo.fetchNewsArticles(
      page: page,
      pageSize: pageSize,
    );
  }
}
