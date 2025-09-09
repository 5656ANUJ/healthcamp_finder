import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterChipsWidget extends StatelessWidget {
  final Map<String, dynamic> appliedFilters;
  final Function(String) onChipRemoved;
  final VoidCallback onClearAll;

  const FilterChipsWidget({
    Key? key,
    required this.appliedFilters,
    required this.onChipRemoved,
    required this.onClearAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chips = _buildFilterChips();

    if (chips.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Active Filters',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onClearAll,
                child: Text(
                  'Clear All',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: chips,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFilterChips() {
    final List<Widget> chips = [];

    // Date range chip
    if (appliedFilters['dateRange'] != null) {
      final dateRange = appliedFilters['dateRange'] as Map<String, DateTime>;
      chips.add(_buildFilterChip(
        'Date: ${_formatDate(dateRange['start']!)} - ${_formatDate(dateRange['end']!)}',
        'dateRange',
        'date_range',
      ));
    }

    // Distance chip
    if (appliedFilters['distance'] != null &&
        appliedFilters['distance'] != 50.0) {
      chips.add(_buildFilterChip(
        'Within ${(appliedFilters['distance'] as double).round()} km',
        'distance',
        'near_me',
      ));
    }

    // Camp types chips
    if (appliedFilters['campTypes'] != null) {
      final campTypes = appliedFilters['campTypes'] as List;
      for (final type in campTypes) {
        chips.add(_buildFilterChip(
          type as String,
          'campType_$type',
          'category',
        ));
      }
    }

    // Available only chip
    if (appliedFilters['availableOnly'] == true) {
      chips.add(_buildFilterChip(
        'Available Only',
        'availableOnly',
        'event_available',
      ));
    }

    return chips;
  }

  Widget _buildFilterChip(String label, String key, String iconName) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 3.5.w,
          ),
          SizedBox(width: 2.w),
          Flexible(
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 2.w),
          GestureDetector(
            onTap: () => onChipRemoved(key),
            child: Container(
              padding: EdgeInsets.all(0.5.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 3.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
