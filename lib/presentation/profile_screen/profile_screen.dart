import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/activity_card_widget.dart';
import './widgets/notification_settings_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_section_widget.dart';
import './widgets/stats_overview_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  // Mock user data
  final Map<String, dynamic> userData = {
    "id": 1,
    "name": "Dr. Sarah Johnson",
    "email": "sarah.johnson@healthcamp.com",
    "phone": "+1 (555) 123-4567",
    "avatar":
        "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
    "memberSince": "January 2023",
    "isOrganizer": true,
    "location": "New York, NY",
    "bio":
        "Healthcare professional passionate about community wellness and preventive care.",
  };

  // Mock notification settings
  Map<String, bool> notificationSettings = {
    "push_notifications": true,
    "camp_reminders": true,
    "new_camps": false,
    "whatsapp_notifications": true,
    "email_updates": false,
  };

  // Mock activity data
  final List<Map<String, dynamic>> recentActivities = [
    {
      "id": 1,
      "title": "Heart Health Screening Camp",
      "date": "Dec 15, 2024",
      "location": "Central Park Community Center",
      "status": "Completed",
      "image":
          "https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
      "type": "registered"
    },
    {
      "id": 2,
      "title": "Diabetes Awareness Workshop",
      "date": "Dec 20, 2024",
      "location": "Downtown Health Center",
      "status": "Upcoming",
      "image":
          "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
      "type": "registered"
    },
    {
      "id": 3,
      "title": "Women's Health Camp",
      "date": "Nov 28, 2024",
      "location": "Community Health Hub",
      "status": "Completed",
      "image":
          "https://images.unsplash.com/photo-1582750433449-648ed127bb54?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
      "type": "favorite"
    },
  ];

  // Mock organizer camps data
  final List<Map<String, dynamic>> organizerCamps = [
    {
      "id": 1,
      "title": "Mental Health Awareness Camp",
      "date": "Jan 10, 2025",
      "location": "City Medical Center",
      "status": "Active",
      "registrations": 45,
      "image":
          "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
    },
    {
      "id": 2,
      "title": "Senior Citizens Health Check",
      "date": "Jan 15, 2025",
      "location": "Riverside Community Hall",
      "status": "Draft",
      "registrations": 12,
      "image":
          "https://images.unsplash.com/photo-1582213782179-e0d53f98f2ca?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProfileHeaderWidget(
              userName: userData["name"] as String,
              memberSince: userData["memberSince"] as String,
              avatarUrl: userData["avatar"] as String,
              onEditAvatar: _showAvatarOptions,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 2.h),
          ),
          SliverToBoxAdapter(
            child: StatsOverviewWidget(
              registeredCamps: 8,
              completedCamps: 5,
              favoriteCamps: 12,
              reviewsGiven: 4,
            ),
          ),
          SliverToBoxAdapter(
            child: ProfileSectionWidget(
              title: 'Account',
              items: [
                ProfileMenuItem(
                  iconName: 'person',
                  iconColor: AppTheme.primaryLight,
                  title: 'Personal Information',
                  subtitle: 'Edit your profile details',
                  onTap: () => _showPersonalInfoDialog(),
                ),
                ProfileMenuItem(
                  iconName: 'security',
                  iconColor: AppTheme.secondaryLight,
                  title: 'Privacy & Security',
                  subtitle: 'Manage your account security',
                  onTap: () => _showPrivacySettings(),
                ),
                ProfileMenuItem(
                  iconName: 'location_on',
                  iconColor: AppTheme.warningLight,
                  title: 'Location Services',
                  subtitle: 'Manage location preferences',
                  trailing: Switch(
                    value: true,
                    onChanged: (value) => _toggleLocationServices(value),
                    activeColor: AppTheme.primaryLight,
                  ),
                  showArrow: false,
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: NotificationSettingsWidget(
              notificationSettings: notificationSettings,
              onSettingChanged: _updateNotificationSetting,
            ),
          ),
          SliverToBoxAdapter(
            child: ProfileSectionWidget(
              title: 'My Activity',
              items: [
                ProfileMenuItem(
                  iconName: 'event_available',
                  iconColor: AppTheme.primaryLight,
                  title: 'Registered Camps',
                  subtitle:
                      '${(recentActivities.where((activity) => activity["type"] == "registered").length)} camps',
                  onTap: () => _showRegisteredCamps(),
                ),
                ProfileMenuItem(
                  iconName: 'favorite',
                  iconColor: AppTheme.errorLight,
                  title: 'Favorite Camps',
                  subtitle:
                      '${(recentActivities.where((activity) => activity["type"] == "favorite").length)} camps',
                  onTap: () => _showFavoriteCamps(),
                ),
                ProfileMenuItem(
                  iconName: 'star',
                  iconColor: AppTheme.warningLight,
                  title: 'My Reviews',
                  subtitle: 'View and manage your reviews',
                  onTap: () => _showMyReviews(),
                ),
              ],
            ),
          ),
          if (userData["isOrganizer"] == true)
            SliverToBoxAdapter(
              child: ProfileSectionWidget(
                title: 'Organizer Dashboard',
                items: [
                  ProfileMenuItem(
                    iconName: 'add_circle',
                    iconColor: AppTheme.primaryLight,
                    title: 'My Listed Camps',
                    subtitle: '${organizerCamps.length} active camps',
                    onTap: () => _showOrganizerCamps(),
                  ),
                  ProfileMenuItem(
                    iconName: 'analytics',
                    iconColor: AppTheme.secondaryLight,
                    title: 'Camp Analytics',
                    subtitle: 'View performance metrics',
                    onTap: () => _showCampAnalytics(),
                  ),
                ],
              ),
            ),
          SliverToBoxAdapter(
            child: ProfileSectionWidget(
              title: 'Settings',
              items: [
                ProfileMenuItem(
                  iconName: 'language',
                  iconColor: AppTheme.accentLight,
                  title: 'Language',
                  subtitle: 'English (US)',
                  onTap: () => _showLanguageSettings(),
                ),
                ProfileMenuItem(
                  iconName: 'accessibility',
                  iconColor: AppTheme.secondaryLight,
                  title: 'Accessibility',
                  subtitle: 'Customize app accessibility',
                  onTap: () => _showAccessibilitySettings(),
                ),
                ProfileMenuItem(
                  iconName: 'dark_mode',
                  iconColor: AppTheme.textSecondaryLight,
                  title: 'Dark Mode',
                  subtitle: 'Switch to dark theme',
                  trailing: Switch(
                    value: false,
                    onChanged: (value) => _toggleDarkMode(value),
                    activeColor: AppTheme.primaryLight,
                  ),
                  showArrow: false,
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: ProfileSectionWidget(
              title: 'Support',
              items: [
                ProfileMenuItem(
                  iconName: 'help',
                  iconColor: AppTheme.primaryLight,
                  title: 'Help & FAQ',
                  subtitle: 'Get answers to common questions',
                  onTap: () => _showHelpCenter(),
                ),
                ProfileMenuItem(
                  iconName: 'contact_support',
                  iconColor: AppTheme.secondaryLight,
                  title: 'Contact Support',
                  subtitle: 'Get help from our team',
                  onTap: () => _contactSupport(),
                ),
                ProfileMenuItem(
                  iconName: 'feedback',
                  iconColor: AppTheme.warningLight,
                  title: 'Send Feedback',
                  subtitle: 'Help us improve the app',
                  onTap: () => _showFeedbackDialog(),
                ),
                ProfileMenuItem(
                  iconName: 'info',
                  iconColor: AppTheme.textSecondaryLight,
                  title: 'About',
                  subtitle: 'App version and information',
                  onTap: () => _showAboutDialog(),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(4.w),
              child: ElevatedButton(
                onPressed: _showLogoutDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorLight,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'logout',
                      color: Colors.white,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Logout',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 10.h),
          ),
        ],
      ),
    );
  }

  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.cardColor,
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
                color: AppTheme.dividerLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Change Profile Picture',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAvatarOption(
                  icon: 'camera_alt',
                  title: 'Camera',
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                _buildAvatarOption(
                  icon: 'photo_library',
                  title: 'Gallery',
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
                _buildAvatarOption(
                  icon: 'delete',
                  title: 'Remove',
                  onTap: () => _removeAvatar(),
                ),
              ],
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarOption({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: AppTheme.primaryLight,
              size: 6.w,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);

    try {
      if (source == ImageSource.camera) {
        final status = await Permission.camera.request();
        if (!status.isGranted) {
          _showPermissionDialog('Camera');
          return;
        }
      }

      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        // In a real app, you would upload the image to a server
        // For now, we'll just show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture updated successfully!'),
            backgroundColor: AppTheme.successLight,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile picture'),
          backgroundColor: AppTheme.errorLight,
        ),
      );
    }
  }

  void _removeAvatar() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile picture removed'),
        backgroundColor: AppTheme.textSecondaryLight,
      ),
    );
  }

  void _showPermissionDialog(String permission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Required'),
        content: Text(
            '$permission permission is required to update your profile picture.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _updateNotificationSetting(String key, bool value) {
    setState(() {
      notificationSettings[key] = value;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification settings updated'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _showPersonalInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Personal Information'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  hintText: userData["name"] as String,
                ),
              ),
              SizedBox(height: 2.h),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: userData["email"] as String,
                ),
              ),
              SizedBox(height: 2.h),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Phone',
                  hintText: userData["phone"] as String,
                ),
              ),
              SizedBox(height: 2.h),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Location',
                  hintText: userData["location"] as String,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Profile updated successfully!'),
                  backgroundColor: AppTheme.successLight,
                ),
              );
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showPrivacySettings() {
    Navigator.pushNamed(context, '/privacy-settings');
  }

  void _toggleLocationServices(bool value) {
    setState(() {
      // Update location services setting
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            value ? 'Location services enabled' : 'Location services disabled'),
        backgroundColor: AppTheme.primaryLight,
      ),
    );
  }

  void _showRegisteredCamps() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.dividerLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Registered Camps',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: recentActivities
                      .where((activity) => activity["type"] == "registered")
                      .length,
                  itemBuilder: (context, index) {
                    final activities = recentActivities
                        .where((activity) => activity["type"] == "registered")
                        .toList();
                    final activity = activities[index];

                    return ActivityCardWidget(
                      title: activity["title"] as String,
                      date: activity["date"] as String,
                      location: activity["location"] as String,
                      status: activity["status"] as String,
                      imageUrl: activity["image"] as String,
                      onTap: () =>
                          Navigator.pushNamed(context, '/camp-details-screen'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFavoriteCamps() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.dividerLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Favorite Camps',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: recentActivities
                      .where((activity) => activity["type"] == "favorite")
                      .length,
                  itemBuilder: (context, index) {
                    final activities = recentActivities
                        .where((activity) => activity["type"] == "favorite")
                        .toList();
                    final activity = activities[index];

                    return ActivityCardWidget(
                      title: activity["title"] as String,
                      date: activity["date"] as String,
                      location: activity["location"] as String,
                      status: activity["status"] as String,
                      imageUrl: activity["image"] as String,
                      onTap: () =>
                          Navigator.pushNamed(context, '/camp-details-screen'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMyReviews() {
    Navigator.pushNamed(context, '/my-reviews');
  }

  void _showOrganizerCamps() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.dividerLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Listed Camps',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/list-camp-screen');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryLight,
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    ),
                    child: Text('Add New'),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: organizerCamps.length,
                  itemBuilder: (context, index) {
                    final camp = organizerCamps[index];

                    return Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      child: ActivityCardWidget(
                        title: camp["title"] as String,
                        date: camp["date"] as String,
                        location: camp["location"] as String,
                        status:
                            '${camp["status"]} • ${camp["registrations"]} registered',
                        imageUrl: camp["image"] as String,
                        onTap: () => Navigator.pushNamed(
                            context, '/camp-details-screen'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCampAnalytics() {
    Navigator.pushNamed(context, '/camp-analytics');
  }

  void _showLanguageSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text('English (US)'),
              value: 'en_US',
              groupValue: 'en_US',
              onChanged: (value) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Language updated to English (US)'),
                    backgroundColor: AppTheme.successLight,
                  ),
                );
              },
            ),
            RadioListTile<String>(
              title: Text('Spanish'),
              value: 'es',
              groupValue: 'en_US',
              onChanged: (value) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Language updated to Spanish'),
                    backgroundColor: AppTheme.successLight,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showAccessibilitySettings() {
    Navigator.pushNamed(context, '/accessibility-settings');
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      // Toggle dark mode
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value ? 'Dark mode enabled' : 'Dark mode disabled'),
        backgroundColor: AppTheme.primaryLight,
      ),
    );
  }

  void _showHelpCenter() {
    Navigator.pushNamed(context, '/help-center');
  }

  void _contactSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Get help from our support team:'),
            SizedBox(height: 2.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'email',
                  color: AppTheme.primaryLight,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text('support@healthcamp.com'),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'phone',
                  color: AppTheme.primaryLight,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text('+1 (555) 123-HELP'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opening email client...'),
                  backgroundColor: AppTheme.primaryLight,
                ),
              );
            },
            child: Text('Send Email'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Send Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Subject',
                hintText: 'Brief description of your feedback',
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Message',
                hintText: 'Tell us what you think...',
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Thank you for your feedback!'),
                  backgroundColor: AppTheme.successLight,
                ),
              );
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('About HealthCamp Finder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0'),
            SizedBox(height: 1.h),
            Text('Build: 2024.12.15'),
            SizedBox(height: 2.h),
            Text(
              'HealthCamp Finder connects you with local health camps and wellness events in your community.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Text(
              '© 2024 HealthCamp Finder. All rights reserved.',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text(
            'Are you sure you want to logout? You will need to sign in again to access your account.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login-screen',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
