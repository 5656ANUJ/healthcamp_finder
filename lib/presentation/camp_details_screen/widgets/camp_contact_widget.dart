import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CampContactWidget extends StatelessWidget {
  final Map<String, dynamic> contactInfo;

  const CampContactWidget({
    Key? key,
    required this.contactInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),

          // Phone Contact
          if (contactInfo['phone'] != null)
            _buildContactItem(
              icon: 'phone',
              title: 'Phone',
              value: contactInfo['phone'] as String,
              onTap: () => _makePhoneCall(contactInfo['phone'] as String),
            ),

          if (contactInfo['phone'] != null) SizedBox(height: 1.5.h),

          // WhatsApp Contact
          if (contactInfo['whatsapp'] != null)
            _buildContactItem(
              icon: 'chat',
              title: 'WhatsApp',
              value: contactInfo['whatsapp'] as String,
              onTap: () => _openWhatsApp(contactInfo['whatsapp'] as String),
              backgroundColor: const Color(0xFF25D366).withValues(alpha: 0.1),
              iconColor: const Color(0xFF25D366),
            ),

          if (contactInfo['whatsapp'] != null) SizedBox(height: 1.5.h),

          // Email Contact
          if (contactInfo['email'] != null)
            _buildContactItem(
              icon: 'email',
              title: 'Email',
              value: contactInfo['email'] as String,
              onTap: () => _sendEmail(contactInfo['email'] as String),
            ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required String icon,
    required String title,
    required String value,
    required VoidCallback onTap,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: (iconColor ?? AppTheme.lightTheme.colorScheme.primary)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: iconColor ?? AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    value,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) {
    // Phone call functionality would be implemented here
    print('Calling: $phoneNumber');
  }

  void _openWhatsApp(String phoneNumber) {
    // WhatsApp functionality would be implemented here
    print('Opening WhatsApp: $phoneNumber');
  }

  void _sendEmail(String email) {
    // Email functionality would be implemented here
    print('Sending email to: $email');
  }
}
