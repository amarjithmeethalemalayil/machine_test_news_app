import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool isHome;
  const CommonAppbar({super.key, this.isHome = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      leading: isHome
          ? Icon(Icons.menu, color: AppColors.bgColor)
          : const BackButton(color: AppColors.bgColor),
      title: Text("News", style: TextStyle(color: AppColors.bgColor)),
      centerTitle: true,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      actions: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.shadowColor,
          child: Icon(
            Icons.notifications_none,
            color: Theme.of(context).colorScheme.primary,
            size: 18,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
