import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CampReviewsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> reviews;
  final double averageRating;

  const CampReviewsWidget({
    Key? key,
    required this.reviews,
    required this.averageRating,
  }) : super(key: key);

  @override
  State<CampReviewsWidget> createState() => _CampReviewsWidgetState();
}

class _CampReviewsWidgetState extends State<CampReviewsWidget> {
  bool _showAllReviews = false;

  @override
  Widget build(BuildContext context) {
    if (widget.reviews.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayReviews =
        _showAllReviews ? widget.reviews : widget.reviews.take(3).toList();

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviews Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reviews & Ratings',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'star',
                      color: Colors.amber,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      widget.averageRating.toStringAsFixed(1),
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '(${widget.reviews.length})',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Reviews List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayReviews.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final review = displayReviews[index];
              return _buildReviewItem(review);
            },
          ),

          // Show More/Less Button
          if (widget.reviews.length > 3) ...[
            SizedBox(height: 2.h),
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _showAllReviews = !_showAllReviews;
                  });
                },
                child: Text(
                  _showAllReviews
                      ? 'Show Less Reviews'
                      : 'Show All ${widget.reviews.length} Reviews',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviewer Info
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                child: Text(
                  (review['userName'] as String).substring(0, 1).toUpperCase(),
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['userName'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        // Star Rating
                        Row(
                          children: List.generate(5, (index) {
                            return CustomIconWidget(
                              iconName: index < (review['rating'] as int)
                                  ? 'star'
                                  : 'star_border',
                              color: Colors.amber,
                              size: 14,
                            );
                          }),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          review['date'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Review Text
          Text(
            review['comment'] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
