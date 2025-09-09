import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/camp_contact_widget.dart';
import './widgets/camp_description_widget.dart';
import './widgets/camp_hero_image_widget.dart';
import './widgets/camp_info_header_widget.dart';
import './widgets/camp_location_widget.dart';
import './widgets/camp_registration_widget.dart';
import './widgets/camp_reviews_widget.dart';
import './widgets/camp_services_widget.dart';

class CampDetailsScreen extends StatefulWidget {
  const CampDetailsScreen({Key? key}) : super(key: key);

  @override
  State<CampDetailsScreen> createState() => _CampDetailsScreenState();
}

class _CampDetailsScreenState extends State<CampDetailsScreen> {
  late ScrollController _scrollController;

  // Mock data for the health camp
  final Map<String, dynamic> _campData = {
    "id": 1,
    "name": "Community Health & Wellness Camp 2024",
    "organizer": "City Health Foundation",
    "date": "December 15, 2024",
    "time": "9:00 AM - 5:00 PM",
    "location": "Community Health Center, 123 Main Street, Downtown",
    "image":
        "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    "description":
        """Join us for a comprehensive health and wellness camp designed to promote community health awareness and provide essential medical services. Our experienced team of healthcare professionals will be conducting various health screenings, consultations, and educational sessions.

This camp focuses on preventive healthcare measures and early detection of common health issues. We believe in making healthcare accessible to everyone in our community, regardless of their economic background.

Our services include general health check-ups, blood pressure monitoring, diabetes screening, eye examinations, dental consultations, and nutritional counseling. All services are provided free of charge by qualified medical professionals.

We also provide health education sessions covering topics such as healthy lifestyle choices, disease prevention, mental health awareness, and proper nutrition. Take this opportunity to learn about maintaining good health and preventing common diseases.""",
    "latitude": 40.7128,
    "longitude": -74.0060,
    "services": [
      {"icon": "favorite", "name": "General Check-up", "available": true},
      {"icon": "visibility", "name": "Eye Examination", "available": true},
      {"icon": "monitor_heart", "name": "Blood Pressure", "available": true},
      {"icon": "bloodtype", "name": "Blood Test", "available": true},
      {"icon": "psychology", "name": "Mental Health", "available": true},
      {"icon": "restaurant", "name": "Nutrition Counseling", "available": true},
      {"icon": "vaccines", "name": "Vaccination", "available": false},
      {"icon": "healing", "name": "Dental Check-up", "available": true},
    ],
    "contact": {
      "phone": "+1 (555) 123-4567",
      "whatsapp": "+1 (555) 123-4567",
      "email": "info@cityhealthfoundation.org"
    },
    "registration": {
      "totalSpots": 200,
      "availableSpots": 45,
      "isRegistered": false,
      "isPastEvent": false
    },
    "reviews": [
      {
        "userName": "Sarah Johnson",
        "rating": 5,
        "comment":
            "Excellent health camp! The staff was very professional and thorough. Got my complete health check-up done for free. Highly recommend to everyone in the community.",
        "date": "Nov 28, 2024"
      },
      {
        "userName": "Michael Chen",
        "rating": 4,
        "comment":
            "Great initiative by the City Health Foundation. The doctors were knowledgeable and took time to explain everything. The only downside was the long waiting time.",
        "date": "Nov 25, 2024"
      },
      {
        "userName": "Emily Rodriguez",
        "rating": 5,
        "comment":
            "Amazing experience! They detected my blood pressure issue early. The nutritionist gave me excellent dietary advice. Thank you for this wonderful service.",
        "date": "Nov 22, 2024"
      },
      {
        "userName": "David Wilson",
        "rating": 4,
        "comment":
            "Well organized health camp with comprehensive services. The eye examination was particularly thorough. Will definitely attend future camps.",
        "date": "Nov 20, 2024"
      },
      {
        "userName": "Lisa Thompson",
        "rating": 5,
        "comment":
            "Outstanding healthcare service! The mental health counseling session was very helpful. All staff members were caring and professional.",
        "date": "Nov 18, 2024"
      }
    ],
    "averageRating": 4.6
  };

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Hero Image Section
          SliverToBoxAdapter(
            child: CampHeroImageWidget(
              imageUrl: _campData['image'] as String,
              onBackPressed: () => Navigator.pop(context),
            ),
          ),

          // Scrollable Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Camp Info Header
                CampInfoHeaderWidget(campData: _campData),

                // Divider
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),

                // Camp Description
                CampDescriptionWidget(
                  description: _campData['description'] as String,
                ),

                // Divider
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),

                // Services Offered
                CampServicesWidget(
                  services: (_campData['services'] as List)
                      .cast<Map<String, dynamic>>(),
                ),

                // Divider
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),

                // Location Section
                CampLocationWidget(
                  latitude: _campData['latitude'] as double,
                  longitude: _campData['longitude'] as double,
                  locationName: _campData['location'] as String,
                ),

                // Divider
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),

                // Contact Information
                CampContactWidget(
                  contactInfo: _campData['contact'] as Map<String, dynamic>,
                ),

                // Divider
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),

                // Reviews Section
                CampReviewsWidget(
                  reviews: (_campData['reviews'] as List)
                      .cast<Map<String, dynamic>>(),
                  averageRating: _campData['averageRating'] as double,
                ),

                // Bottom spacing for registration widget
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ],
      ),

      // Fixed Registration Section at Bottom
      bottomNavigationBar: CampRegistrationWidget(
        registrationData: _campData['registration'] as Map<String, dynamic>,
        onRegister: _handleRegistration,
      ),
    );
  }

  void _handleRegistration() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            const Text('Successfully registered for the health camp!'),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }
}
