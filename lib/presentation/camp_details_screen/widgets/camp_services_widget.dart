import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CampServicesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> services;

  const CampServicesWidget({
    Key? key,
    required this.services,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Services Offered',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: (services as List).map<Widget>((service) {
              return _buildServiceChip(
                icon: (service as Map<String, dynamic>)['icon'] as String,
                name: (service)['name'] as String,
                isAvailable:
                    (service)['available'] as bool? ??
                        true,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceChip({
    required String icon,
    required String name,
    required bool isAvailable,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: isAvailable
            ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isAvailable
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: isAvailable
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 18,
          ),
          SizedBox(width: 2.w),
          Text(
            name,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: isAvailable
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
