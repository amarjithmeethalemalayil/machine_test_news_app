import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:machine_test_news_app/core/constants/asset_helper/asset_helper.dart';
import 'package:machine_test_news_app/features/presentation/utils/time_formater.dart';
import '../../../core/theme/app_colors.dart';

class NewsBox extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final Object obj;
  final String publishedAt;

  const NewsBox({
    super.key,
    this.imageUrl,
    required this.title,
    required this.publishedAt,
    required this.obj,
  });

  @override
  Widget build(BuildContext context) {
    final String displayImage = imageUrl ?? '';

    return Card(
      color: AppColors.bgColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: obj,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: displayImage.isEmpty
                    ? Image.asset(
                        AssetHelper.placeholderImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    : CachedNetworkImage(
                        imageUrl: displayImage,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.border,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.border,
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 48,
                              color: AppColors.shadowColor,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      TimeFormater.formatPublishedDate(publishedAt),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
