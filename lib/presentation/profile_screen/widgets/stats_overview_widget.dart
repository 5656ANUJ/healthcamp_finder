import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatsOverviewWidget extends StatelessWidget {
  final int registeredCamps;
  final int completedCamps;
  final int favoriteCamps;
  final int reviewsGiven;

  const StatsOverviewWidget({
    Key? key,
    required this.registeredCamps,
    required this.completedCamps,
    required this.favoriteCamps,
    required this.reviewsGiven,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        'title': 'Registered',
        'value': registeredCamps.toString(),
        'icon': 'event_available',
        'color': AppTheme.primaryLight,
      },
      {
        'title': 'Completed',
        'value': completedCamps.toString(),
        'icon': 'check_circle',
        'color': AppTheme.successLight,
      },
      {
        'title': 'Favorites',
        'value': favoriteCamps.toString(),
        'icon': 'favorite',
        'color': AppTheme.errorLight,
      },
      {
        'title': 'Reviews',
        'value': reviewsGiven.toString(),
        'icon': 'star',
        'color': AppTheme.warningLight,
      },
    ];

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
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Activity Overview',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryLight,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: stats.map((stat) {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: (stat['color'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: stat['icon'] as String,
                          color: stat['color'] as Color,
                          size: 6.w,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          stat['value'] as String,
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: stat['color'] as Color,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          stat['title'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
