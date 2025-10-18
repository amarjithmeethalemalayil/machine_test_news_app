import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  bool _isInitialized = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      Future.microtask(() => _fetchNews());
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppbar(),
      body: SafeArea(
        child: Consumer<NewsProvider>(
          builder: (context, provider, child) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // 🔍 Search Box
                    SearchBox(
                      controller: _searchController,
                      onChanged: _handleSearch,
                      onSubmitted: _handleSearch,
                    ),
                    const SizedBox(height: 24),

                    // 📰 Section Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          provider.searchQuery.isEmpty
                              ? 'Breaking News'
                              : 'Search Results',
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
                    ),
                    const SizedBox(height: 16),

                    // ⏳ Loading State
                    if (provider.isLoading)
                      const Center(child: CircularProgressIndicator())

                    // ⚠️ Error State
                    else if (provider.errorMessage != null)
                      Center(child: Text(provider.errorMessage!))

                    // ✅ News List
                    else
                      ListView.builder(
                        itemCount: provider.articles.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final Article news = provider.articles[index];
                          final String uniqueKey = '${news.title}_$index';
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: InkWell(
                              key: ValueKey(uniqueKey),
                              onTap: () {
                              },
                              child: NewsBox(
                                key: ValueKey(uniqueKey),
                                obj: uniqueKey,
                                imageUrl: news.urlToImage ??
                                    'https://via.placeholder.com/150',
                                title: news.title ?? 'No title',
                                publishedAt: (news.publishedAt ?? DateTime.now()).toIso8601String(),
                              ),
                            ),
                          );
                        },
                      ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
