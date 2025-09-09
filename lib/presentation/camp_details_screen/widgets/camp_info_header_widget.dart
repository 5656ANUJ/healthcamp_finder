import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CampInfoHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> campData;

  const CampInfoHeaderWidget({
    Key? key,
    required this.campData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Camp Name
          Text(
            campData['name'] ?? 'Health Camp',
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),

          // Organizer Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'verified',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Organized by ${campData['organizer'] ?? 'Health Organization'}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),

          // Key Details Row
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  icon: 'calendar_today',
                  title: 'Date',
                  value: campData['date'] ?? 'Dec 15, 2024',
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildDetailItem(
                  icon: 'access_time',
                  title: 'Time',
                  value: campData['time'] ?? '9:00 AM - 5:00 PM',
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Location Detail
          _buildDetailItem(
            icon: 'location_on',
            title: 'Location',
            value: campData['location'] ?? 'Community Health Center, Downtown',
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required String icon,
    required String title,
    required String value,
    bool isFullWidth = false,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 18,
              ),
              SizedBox(width: 2.w),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: isFullWidth ? 2 : 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
