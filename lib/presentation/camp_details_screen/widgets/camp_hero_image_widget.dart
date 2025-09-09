import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CampHeroImageWidget extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onBackPressed;

  const CampHeroImageWidget({
    Key? key,
    required this.imageUrl,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.h,
      width: double.infinity,
      child: Stack(
        children: [
          // Hero Image
          CustomImageWidget(
            imageUrl: imageUrl,
            width: double.infinity,
            height: 35.h,
            fit: BoxFit.cover,
          ),
          // Gradient Overlay
          Container(
            height: 35.h,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          // Back Button
          Positioned(
            top: 6.h,
            left: 4.w,
            child: GestureDetector(
              onTap: onBackPressed,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          // Share Button
          Positioned(
            top: 6.h,
            right: 4.w,
            child: GestureDetector(
              onTap: () => _shareDetails(context),
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'share',
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _shareDetails(BuildContext context) {
    // Share functionality would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon')),
    );
  }
}
