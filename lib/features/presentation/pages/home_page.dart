import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test_news_app/features/presentation/widgets/error_text.dart';
import 'package:machine_test_news_app/features/presentation/widgets/loader.dart';
import 'package:machine_test_news_app/features/presentation/bloc/news_bloc.dart';
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
    // avoid using BuildContext across async gaps — post-frame with mounted check
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<NewsBloc>().add(const FetchNewsEvent(page: 1, pageSize: 10));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ensure BuildContext is not used after awaits by capturing bloc first
  Future<void> _onRefresh() async {
    final bloc = context.read<NewsBloc>();
    bloc.add(const FetchNewsEvent(page: 1, pageSize: 10));
    // If you await something here later, continue to use `bloc` instead of `context`
  }

  void _handleSearch(String query) {
    // synchronous usage is fine; if you make this async later capture bloc first
    context.read<NewsBloc>().add(SearchArticlesEvent(query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppbar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          child: BlocBuilder<NewsBloc, NewsState>(
            builder: (context, state) {
              List<Article> articles = [];
              String searchQuery = '';
              if (state is NewsLoading) {
                return _newsLoading();
              }
              if (state is NewsError) {
                return _newsError(state.message);
              }
              if (state is NewsLoaded) {
                articles = state.articles;
                searchQuery = state.searchQuery;
              }
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
                      _topHeader(searchQuery),
                      const SizedBox(height: 16),
                      if (state is NewsLoading)
                        _centeredChild(const Loader())
                      else if (state is NewsError)
                        _centeredChild(ErrorText(errorMessage: state.message))
                      else if (articles.isEmpty)
                        _centeredChild(
                          const ErrorText(errorMessage: 'No articles found.'),
                        )
                      else
                        _newsList(articles),
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

  Widget _newsLoading() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            SearchBox(
              controller: _searchController,
              onChanged: _handleSearch,
              onSubmitted: _handleSearch,
            ),
            const SizedBox(height: 24),
            _topHeader(''),
            const SizedBox(height: 16),
            _centeredChild(const Loader()),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _newsError(String message) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            SearchBox(
              controller: _searchController,
              onChanged: _handleSearch,
              onSubmitted: _handleSearch,
            ),
            const SizedBox(height: 24),
            _topHeader(''),
            const SizedBox(height: 16),
            _centeredChild(ErrorText(errorMessage: message)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _topHeader(String searchQuery) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          searchQuery.isEmpty ? 'Breaking News' : 'Search Results',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        if (searchQuery.isNotEmpty)
          TextButton(
            onPressed: () {
              _searchController.clear();
              context.read<NewsBloc>().add(ClearSearchEvent());
            },
            child: const Text('Clear'),
          ),
      ],
    );
  }

  Widget _newsList(List<Article> articles) {
    return ListView.separated(
      itemCount: articles.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final Article news = articles[index];
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
