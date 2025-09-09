import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationSettingsWidget extends StatefulWidget {
  final Map<String, bool> notificationSettings;
  final Function(String, bool) onSettingChanged;

  const NotificationSettingsWidget({
    Key? key,
    required this.notificationSettings,
    required this.onSettingChanged,
  }) : super(key: key);

  @override
  State<NotificationSettingsWidget> createState() =>
      _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState
    extends State<NotificationSettingsWidget> {
  @override
  Widget build(BuildContext context) {
    final settings = [
      {
        'key': 'push_notifications',
        'title': 'Push Notifications',
        'subtitle': 'Receive app notifications',
        'icon': 'notifications',
      },
      {
        'key': 'camp_reminders',
        'title': 'Camp Reminders',
        'subtitle': 'Get reminded about upcoming camps',
        'icon': 'event',
      },
      {
        'key': 'new_camps',
        'title': 'New Camps',
        'subtitle': 'Notify when new camps are added',
        'icon': 'add_circle',
      },
      {
        'key': 'whatsapp_notifications',
        'title': 'WhatsApp Notifications',
        'subtitle': 'Receive updates via WhatsApp',
        'icon': 'message',
      },
      {
        'key': 'email_updates',
        'title': 'Email Updates',
        'subtitle': 'Get weekly health camp updates',
        'icon': 'email',
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'Notification Preferences',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryLight,
              ),
            ),
          ),
          ...settings.asMap().entries.map((entry) {
            final index = entry.key;
            final setting = entry.value;
            final isLast = index == settings.length - 1;
            final key = setting['key'] as String;
            final isEnabled = widget.notificationSettings[key] ?? false;

            return Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: setting['icon'] as String,
                      color: AppTheme.primaryLight,
                      size: 5.w,
                    ),
                  ),
                  title: Text(
                    setting['title'] as String,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    setting['subtitle'] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                  trailing: Switch(
                    value: isEnabled,
                    onChanged: (value) {
                      widget.onSettingChanged(key, value);
                    },
                    activeColor: AppTheme.primaryLight,
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    indent: 18.w,
                    endIndent: 4.w,
                    color: AppTheme.dividerLight,
                  ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
