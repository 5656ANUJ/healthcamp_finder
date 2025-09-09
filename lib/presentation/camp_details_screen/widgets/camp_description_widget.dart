import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CampDescriptionWidget extends StatefulWidget {
  final String description;

  const CampDescriptionWidget({
    Key? key,
    required this.description,
  }) : super(key: key);

  @override
  State<CampDescriptionWidget> createState() => _CampDescriptionWidgetState();
}

class _CampDescriptionWidgetState extends State<CampDescriptionWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About This Camp',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Text(
              widget.description,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                height: 1.6,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              maxLines: _isExpanded ? null : 4,
              overflow:
                  _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
          ),
          if (widget.description.length > 200) ...[
            SizedBox(height: 1.h),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Row(
                children: [
                  Text(
                    _isExpanded ? 'Show Less' : 'Read More',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 1.w),
                  CustomIconWidget(
                    iconName: _isExpanded
                        ? 'keyboard_arrow_up'
                        : 'keyboard_arrow_down',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
