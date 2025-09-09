import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CampCardWidget extends StatelessWidget {
  final Map<String, dynamic> camp;
  final VoidCallback onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onShare;
  final VoidCallback? onDirections;

  const CampCardWidget({
    Key? key,
    required this.camp,
    required this.onTap,
    this.onFavorite,
    this.onShare,
    this.onDirections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showQuickActions(context),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCampImage(),
            _buildCampDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildCampImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Stack(
        children: [
          CustomImageWidget(
            imageUrl: camp['image'] as String? ?? '',
            width: double.infinity,
            height: 20.h,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 2.h,
            right: 3.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: _getAvailabilityColor().withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                camp['availability'] as String? ?? 'Available',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if ((camp['isFavorite'] as bool?) == true)
            Positioned(
              top: 2.h,
              left: 3.w,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface
                      .withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'favorite',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 4.w,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCampDetails() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            camp['name'] as String? ?? 'Health Camp',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.h),
          _buildInfoRow('schedule', camp['date'] as String? ?? 'TBD'),
          SizedBox(height: 0.5.h),
          _buildInfoRow(
              'location_on', camp['location'] as String? ?? 'Location TBD'),
          SizedBox(height: 0.5.h),
          _buildInfoRow(
              'near_me', '${camp['distance'] as String? ?? '0'} km away'),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    camp['type'] as String? ?? 'General Health',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              GestureDetector(
                onTap: onFavorite,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: (camp['isFavorite'] as bool?) == true
                        ? 'favorite'
                        : 'favorite_border',
                    color: (camp['isFavorite'] as bool?) == true
                        ? AppTheme.lightTheme.colorScheme.error
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String iconName, String text) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 4.w,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Text(
            text,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getAvailabilityColor() {
    final availability = camp['availability'] as String? ?? 'Available';
    switch (availability.toLowerCase()) {
      case 'full':
        return AppTheme.lightTheme.colorScheme.error;
      case 'limited':
        return const Color(0xFFF66A0A); // Warning color
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Quick Actions',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildQuickActionTile(
              context,
              'favorite',
              'Add to Favorites',
              onFavorite,
            ),
            _buildQuickActionTile(
              context,
              'share',
              'Share Camp',
              onShare,
            ),
            _buildQuickActionTile(
              context,
              'directions',
              'Get Directions',
              onDirections,
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionTile(
    BuildContext context,
    String iconName,
    String title,
    VoidCallback? onTap,
  ) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 6.w,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium,
      ),
      onTap: () {
        Navigator.pop(context);
        onTap?.call();
      },
    );
  }
}
