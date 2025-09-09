import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActivityCardWidget extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final String status;
  final String imageUrl;
  final VoidCallback? onTap;

  const ActivityCardWidget({
    Key? key,
    required this.title,
    required this.date,
    required this.location,
    required this.status,
    required this.imageUrl,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor = _getStatusColor(status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          padding: EdgeInsets.all(3.w),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: imageUrl,
                  width: 15.w,
                  height: 15.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'calendar_today',
                          color: AppTheme.textSecondaryLight,
                          size: 3.w,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          date,
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_on',
                          color: AppTheme.textSecondaryLight,
                          size: 3.w,
                        ),
                        SizedBox(width: 1.w),
                        Expanded(
                          child: Text(
                            location,
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppTheme.successLight;
      case 'upcoming':
        return AppTheme.primaryLight;
      case 'cancelled':
        return AppTheme.errorLight;
      case 'registered':
        return AppTheme.secondaryLight;
      default:
        return AppTheme.textSecondaryLight;
    }
  }
}
