import 'package:flutter/material.dart';
import 'package:machine_test_news_app/core/theme/app_colors.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSubmitted;
  final void Function(String)? onChanged;

  const SearchBox({
    super.key,
    required this.controller,
    required this.onSubmitted,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.shadowColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        onSubmitted: onSubmitted,
        onChanged: onChanged ?? onSubmitted,
        decoration: InputDecoration(
          hintText: 'Search for news...',
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
