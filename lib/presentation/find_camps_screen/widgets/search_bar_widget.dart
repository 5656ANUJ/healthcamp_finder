import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onFilterTap;
  final int filterCount;

  const SearchBarWidget({
    Key? key,
    required this.onSearchChanged,
    required this.onFilterTap,
    this.filterCount = 0,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 6.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: widget.onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search camps, locations, specialties...',
                  hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'medical_services',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 5.w,
                    ),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            widget.onSearchChanged('');
                          },
                          icon: CustomIconWidget(
                            iconName: 'clear',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 5.w,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.5.h,
                  ),
                ),
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          GestureDetector(
            onTap: widget.onFilterTap,
            child: Container(
              height: 6.h,
              width: 12.w,
              decoration: BoxDecoration(
                color: widget.filterCount > 0
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.filterCount > 0
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline,
                  width: 1,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'tune',
                    color: widget.filterCount > 0
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  if (widget.filterCount > 0)
                    Positioned(
                      top: 0.5.h,
                      right: 2.w,
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 4.w,
                          minHeight: 4.w,
                        ),
                        child: Text(
                          widget.filterCount.toString(),
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onError,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
