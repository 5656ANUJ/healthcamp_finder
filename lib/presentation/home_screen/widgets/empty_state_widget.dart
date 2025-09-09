import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onExpandSearch;

  const EmptyStateWidget({
    Key? key,
    required this.onExpandSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'local_hospital',
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.5),
            size: 80,
          ),
          SizedBox(height: 3.h),
          Text(
            'No Health Camps Nearby',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'We couldn\'t find any health camps in your area right now. Try expanding your search radius to discover more opportunities.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton.icon(
            onPressed: onExpandSearch,
            icon: CustomIconWidget(
              iconName: 'my_location',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 20,
            ),
            label: Text('Expand Search Radius'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            ),
          ),
        ],
      ),
    );
  }
}
