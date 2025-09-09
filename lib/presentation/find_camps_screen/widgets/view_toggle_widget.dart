import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

enum ViewType { list, map }

class ViewToggleWidget extends StatelessWidget {
  final ViewType selectedView;
  final Function(ViewType) onViewChanged;

  const ViewToggleWidget({
    Key? key,
    required this.selectedView,
    required this.onViewChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
              context,
              ViewType.list,
              'List',
              'list',
            ),
          ),
          Expanded(
            child: _buildToggleButton(
              context,
              ViewType.map,
              'Map',
              'map',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
    BuildContext context,
    ViewType viewType,
    String label,
    String iconName,
  ) {
    final bool isSelected = selectedView == viewType;

    return GestureDetector(
      onTap: () => onViewChanged(viewType),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.onPrimary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
