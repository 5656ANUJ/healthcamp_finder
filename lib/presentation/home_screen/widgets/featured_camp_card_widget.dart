import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FeaturedCampCardWidget extends StatelessWidget {
  final Map<String, dynamic> camp;
  final VoidCallback onTap;
  final VoidCallback onRegister;

  const FeaturedCampCardWidget({
    Key? key,
    required this.camp,
    required this.onTap,
    required this.onRegister,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70.w,
        margin: EdgeInsets.only(right: 3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: CustomImageWidget(
                imageUrl: camp['image'] as String,
                width: double.infinity,
                height: 20.h,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    camp['name'] as String,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'calendar_today',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          camp['date'] as String,
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onRegister,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Quick Register',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
