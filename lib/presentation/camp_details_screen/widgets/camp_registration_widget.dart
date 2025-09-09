import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CampRegistrationWidget extends StatefulWidget {
  final Map<String, dynamic> registrationData;
  final VoidCallback onRegister;

  const CampRegistrationWidget({
    Key? key,
    required this.registrationData,
    required this.onRegister,
  }) : super(key: key);

  @override
  State<CampRegistrationWidget> createState() => _CampRegistrationWidgetState();
}

class _CampRegistrationWidgetState extends State<CampRegistrationWidget> {
  bool _isRegistered = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isRegistered = widget.registrationData['isRegistered'] as bool? ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final availableSpots =
        widget.registrationData['availableSpots'] as int? ?? 0;
    final totalSpots = widget.registrationData['totalSpots'] as int? ?? 100;
    final registeredCount = totalSpots - availableSpots;
    final isFull = availableSpots <= 0;
    final isPastEvent =
        widget.registrationData['isPastEvent'] as bool? ?? false;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Registration Status Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Registration',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: _isFavorite
                        ? AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: _isFavorite ? 'favorite' : 'favorite_border',
                    color: _isFavorite
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Availability Info
          if (!isPastEvent) ...[
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color:
                    _getStatusColor(isFull, isPastEvent).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getStatusColor(isFull, isPastEvent)
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName:
                        _getStatusIcon(isFull, isPastEvent, _isRegistered),
                    color: _getStatusColor(isFull, isPastEvent),
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getStatusText(isFull, isPastEvent, _isRegistered),
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: _getStatusColor(isFull, isPastEvent),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (!isFull && !_isRegistered) ...[
                          SizedBox(height: 0.5.h),
                          Text(
                            '$registeredCount/$totalSpots participants registered',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
          ],

          // Registration Button
          SizedBox(
            width: double.infinity,
            child: _buildRegistrationButton(isFull, isPastEvent),
          ),

          // Add to Calendar Button (if registered)
          if (_isRegistered && !isPastEvent) ...[
            SizedBox(height: 1.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _addToCalendar,
                icon: CustomIconWidget(
                  iconName: 'calendar_today',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                label: Text(
                  'Add to Calendar',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRegistrationButton(bool isFull, bool isPastEvent) {
    if (isPastEvent) {
      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          padding: EdgeInsets.symmetric(vertical: 2.h),
        ),
        child: Text(
          'Event Completed',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.surface,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    if (_isRegistered) {
      return ElevatedButton.icon(
        onPressed: null,
        icon: CustomIconWidget(
          iconName: 'check_circle',
          color: Colors.white,
          size: 20,
        ),
        label: Text(
          'Registered',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          padding: EdgeInsets.symmetric(vertical: 2.h),
        ),
      );
    }

    if (isFull) {
      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          padding: EdgeInsets.symmetric(vertical: 2.h),
        ),
        child: Text(
          'Registration Full',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.surface,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isRegistered = true;
        });
        widget.onRegister();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        padding: EdgeInsets.symmetric(vertical: 2.h),
      ),
      child: Text(
        'Register Now',
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStatusColor(bool isFull, bool isPastEvent) {
    if (isPastEvent) return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    if (_isRegistered) return AppTheme.lightTheme.colorScheme.primary;
    if (isFull) return AppTheme.lightTheme.colorScheme.error;
    return AppTheme.lightTheme.colorScheme.primary;
  }

  String _getStatusIcon(bool isFull, bool isPastEvent, bool isRegistered) {
    if (isPastEvent) return 'event_busy';
    if (isRegistered) return 'check_circle';
    if (isFull) return 'event_busy';
    return 'event_available';
  }

  String _getStatusText(bool isFull, bool isPastEvent, bool isRegistered) {
    if (isPastEvent) return 'Event has ended';
    if (isRegistered) return 'You are registered for this camp';
    if (isFull) return 'Registration is full';
    return 'Registration is open';
  }

  void _addToCalendar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Adding to calendar...')),
    );
  }
}
