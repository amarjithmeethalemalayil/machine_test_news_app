import 'package:flutter/material.dart';
import 'package:machine_test_news_app/core/theme/app_colors.dart';
import 'package:machine_test_news_app/features/presentation/widgets/common_appbar.dart';

class NewsDetailPage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String content;
  final String author;
  final String publishedAt;
  final String heroTag;

  const NewsDetailPage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.content,
    required this.author,
    required this.publishedAt,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(isHome: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Hero(
                tag: heroTag,
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowColor,
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _authorSection(),
              const SizedBox(height: 16),
              Text(
                content,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(height: 1.6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _authorSection() {
    return Row(
      children: [
        const CircleAvatar(radius: 20, child: Icon(Icons.person, size: 24)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(author, style: TextStyle(fontWeight: FontWeight.w600)),
            Text(publishedAt, style: TextStyle(color: AppColors.shadowColor)),
          ],
        ),
      ],
    );
  }
}
