import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileSectionWidget extends StatelessWidget {
  final String title;
  final List<ProfileMenuItem> items;

  const ProfileSectionWidget({
    Key? key,
    required this.title,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryLight,
              ),
            ),
          ),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == items.length - 1;

            return Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: item.iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: item.iconName,
                      color: item.iconColor,
                      size: 5.w,
                    ),
                  ),
                  title: Text(
                    item.title,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: item.subtitle != null
                      ? Text(
                          item.subtitle!,
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        )
                      : null,
                  trailing: item.showArrow
                      ? CustomIconWidget(
                          iconName: 'chevron_right',
                          color: AppTheme.textSecondaryLight,
                          size: 5.w,
                        )
                      : item.trailing,
                  onTap: item.onTap,
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    indent: 18.w,
                    endIndent: 4.w,
                    color: AppTheme.dividerLight,
                  ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}

class ProfileMenuItem {
  final String iconName;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final bool showArrow;
  final Widget? trailing;
  final VoidCallback? onTap;

  ProfileMenuItem({
    required this.iconName,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.showArrow = true,
    this.trailing,
    this.onTap,
  });
}
