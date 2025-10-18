import 'package:flutter/material.dart';
import 'package:machine_test_news_app/features/presentation/utils/news_state.dart';
import 'package:provider/provider.dart';
import 'package:machine_test_news_app/features/presentation/widgets/error_text.dart';
import 'package:machine_test_news_app/features/presentation/widgets/loader.dart';
import 'package:machine_test_news_app/features/presentation/provider/news_provider.dart';
import '../../domain/entity/article_entity.dart';
import '../widgets/common_appbar.dart';
import '../widgets/search_box.dart';
import '../widgets/news_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(_fetchNews);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchNews() async {
    final provider = Provider.of<NewsProvider>(context, listen: false);
    await provider.fetchNewsArticles(page: 1, pageSize: 10);
  }

  Future<void> _onRefresh() async {
    return _fetchNews();
  }

  void _handleSearch(String query) {
    final provider = Provider.of<NewsProvider>(context, listen: false);
    provider.searchArticles(query);
  }

  NewsState _getState(NewsProvider provider) {
    if (provider.isLoading) return NewsState.loading;
    if (provider.errorMessage != null) return NewsState.error;
    if (provider.articles.isEmpty) return NewsState.empty;
    return NewsState.success;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppbar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          child: Consumer<NewsProvider>(
            builder: (context, provider, child) {
              final state = _getState(provider);
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      SearchBox(
                        controller: _searchController,
                        onChanged: _handleSearch,
                        onSubmitted: _handleSearch,
                      ),
                      const SizedBox(height: 24),
                      _topHeader(provider),
                      const SizedBox(height: 16),
                      if (state == NewsState.loading)
                        _centeredChild(const Loader())
                      else if (state == NewsState.error)
                        _centeredChild(
                          ErrorText(errorMessage: provider.errorMessage),
                        )
                      else if (state == NewsState.empty)
                        _centeredChild(
                          const ErrorText(errorMessage: 'No articles found.'),
                        )
                      else
                        _newsList(provider),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _topHeader(NewsProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          provider.searchQuery.isEmpty ? 'Breaking News' : 'Search Results',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        if (provider.searchQuery.isNotEmpty)
          TextButton(
            onPressed: () {
              _searchController.clear();
              provider.clearSearch();
            },
            child: const Text('Clear'),
          ),
      ],
    );
  }

  Widget _newsList(NewsProvider provider) {
    return ListView.separated(
      itemCount: provider.articles.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final Article news = provider.articles[index];
        final String uniqueKey = '${news.title}_$index';
        return InkWell(
          key: ValueKey(uniqueKey),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/news-detail',
              arguments: {
                'imageUrl': news.urlToImage,
                'title': news.title ?? 'No title',
                'content': news.content ?? 'No content available',
                'author': news.author ?? 'Unknown',
                'publishedAt': news.publishedAt?.toIso8601String() ?? 'unkown',
                'heroTag': uniqueKey,
              },
            );
          },
          child: NewsBox(
            key: ValueKey(uniqueKey),
            obj: uniqueKey,
            imageUrl: news.urlToImage ?? 'https://via.placeholder.com/150',
            title: news.title ?? 'No title',
            publishedAt: (news.publishedAt ?? DateTime.now()).toIso8601String(),
          ),
        );
      },
    );
  }

  Widget _centeredChild(Widget child) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(child: child),
    );
  }
}
