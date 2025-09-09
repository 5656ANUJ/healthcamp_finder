import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/camp_card_widget.dart';
import './widgets/category_chip_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/featured_camp_card_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _selectedCategory = 'All';
  List<String> _favoriteIds = [];
  bool _isRefreshing = false;
  String _searchQuery = '';

  // Mock data for featured camps
  final List<Map<String, dynamic>> _featuredCamps = [
    {
      "id": "1",
      "name": "Free Eye Checkup Camp",
      "image":
          "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "date": "Dec 15, 2024",
      "category": "Eye Care",
      "location": "Community Center",
      "organizer": "Vision Care Foundation"
    },
    {
      "id": "2",
      "name": "Women's Health Screening",
      "image":
          "https://images.pexels.com/photos/4173251/pexels-photo-4173251.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "date": "Dec 18, 2024",
      "category": "Women's Health",
      "location": "City Hospital",
      "organizer": "Women's Wellness Group"
    },
    {
      "id": "3",
      "name": "General Health Checkup",
      "image":
          "https://images.pixabay.com/photo/2017/12/24/20/12/stethoscope-3038740_1280.jpg",
      "date": "Dec 20, 2024",
      "category": "General Health",
      "location": "Medical Center",
      "organizer": "Health First Initiative"
    }
  ];

  // Mock data for health camp categories
  final List<Map<String, dynamic>> _categories = [
    {"name": "All", "icon": "local_hospital"},
    {"name": "General Health", "icon": "health_and_safety"},
    {"name": "Dental", "icon": "medical_services"},
    {"name": "Eye Care", "icon": "visibility"},
    {"name": "Women's Health", "icon": "pregnant_woman"},
  ];

  // Mock data for nearby camps
  final List<Map<String, dynamic>> _nearbyCamps = [
    {
      "id": "4",
      "name": "Dental Care Camp",
      "image":
          "https://images.pexels.com/photos/6812540/pexels-photo-6812540.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "date": "Dec 16, 2024",
      "time": "9:00 AM - 4:00 PM",
      "location": "Downtown Clinic",
      "distance": "1.2 km away",
      "category": "Dental",
      "availability": 25,
      "organizer": "Smile Foundation"
    },
    {
      "id": "5",
      "name": "Blood Pressure Screening",
      "image":
          "https://images.pixabay.com/photo/2017/08/25/15/10/heart-2680842_1280.jpg",
      "date": "Dec 17, 2024",
      "time": "8:00 AM - 2:00 PM",
      "location": "Health Center",
      "distance": "2.1 km away",
      "category": "General Health",
      "availability": 15,
      "organizer": "Heart Care Society"
    },
    {
      "id": "6",
      "name": "Diabetes Awareness Camp",
      "image":
          "https://images.unsplash.com/photo-1559757175-0eb30cd8c063?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "date": "Dec 19, 2024",
      "time": "10:00 AM - 3:00 PM",
      "location": "Community Hall",
      "distance": "0.8 km away",
      "category": "General Health",
      "availability": 0,
      "organizer": "Diabetes Care Foundation"
    },
    {
      "id": "7",
      "name": "Pediatric Health Camp",
      "image":
          "https://images.pexels.com/photos/4167541/pexels-photo-4167541.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "date": "Dec 21, 2024",
      "time": "9:00 AM - 5:00 PM",
      "location": "Children's Hospital",
      "distance": "3.5 km away",
      "category": "General Health",
      "availability": 30,
      "organizer": "Kids Health Initiative"
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadFavorites() {
    // Mock loading favorites from local storage
    setState(() {
      _favoriteIds = ['1', '4']; // Mock favorite IDs
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });

    Fluttertoast.showToast(
      msg: "Health camps updated!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _toggleFavorite(String campId) {
    setState(() {
      if (_favoriteIds.contains(campId)) {
        _favoriteIds.remove(campId);
        Fluttertoast.showToast(
          msg: "Removed from favorites",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        _favoriteIds.add(campId);
        Fluttertoast.showToast(
          msg: "Added to favorites",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  void _navigateToCampDetails(String campId) {
    Navigator.pushNamed(context, '/camp-details-screen');
  }

  void _navigateToListCamp() {
    Navigator.pushNamed(context, '/list-camp-screen');
  }

  void _navigateToFindCamps() {
    Navigator.pushNamed(context, '/find-camps-screen');
  }

  void _quickRegister(String campId) {
    Fluttertoast.showToast(
      msg: "Registration successful! Check your notifications.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _expandSearchRadius() {
    Fluttertoast.showToast(
      msg: "Expanding search radius...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  List<Map<String, dynamic>> _getFilteredCamps() {
    List<Map<String, dynamic>> filteredCamps = List.from(_nearbyCamps);

    // Filter by category
    if (_selectedCategory != 'All') {
      filteredCamps = filteredCamps
          .where((camp) => (camp['category'] as String) == _selectedCategory)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filteredCamps = filteredCamps
          .where((camp) =>
              (camp['name'] as String).toLowerCase().contains(_searchQuery) ||
              (camp['location'] as String)
                  .toLowerCase()
                  .contains(_searchQuery) ||
              (camp['category'] as String).toLowerCase().contains(_searchQuery))
          .toList();
    }

    return filteredCamps;
  }

  @override
  Widget build(BuildContext context) {
    final filteredCamps = _getFilteredCamps();

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: AppTheme.lightTheme.colorScheme.primary,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Greeting Header
              SliverToBoxAdapter(
                child: GreetingHeaderWidget(
                  userName: "Sarah",
                  location: "Downtown",
                ),
              ),

              // Search Bar
              SliverToBoxAdapter(
                child: SearchBarWidget(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  onTap: _navigateToFindCamps,
                ),
              ),

              // Featured Camps Section
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Featured Camps',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          GestureDetector(
                            onTap: _navigateToFindCamps,
                            child: Text(
                              'View All',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 35.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        itemCount: _featuredCamps.length,
                        itemBuilder: (context, index) {
                          final camp = _featuredCamps[index];
                          return FeaturedCampCardWidget(
                            camp: camp,
                            onTap: () =>
                                _navigateToCampDetails(camp['id'] as String),
                            onRegister: () =>
                                _quickRegister(camp['id'] as String),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Categories Section
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      child: Text(
                        'Categories',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          return CategoryChipWidget(
                            category: category,
                            isSelected: _selectedCategory == category['name'],
                            onTap: () =>
                                _onCategorySelected(category['name'] as String),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Nearby Camps Section Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Text(
                    'Nearby Health Camps',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              // Nearby Camps List or Empty State
              filteredCamps.isEmpty
                  ? SliverFillRemaining(
                      child: EmptyStateWidget(
                        onExpandSearch: _expandSearchRadius,
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final camp = filteredCamps[index];
                          return CampCardWidget(
                            camp: camp,
                            onTap: () =>
                                _navigateToCampDetails(camp['id'] as String),
                            onFavorite: () =>
                                _toggleFavorite(camp['id'] as String),
                            isFavorite: _favoriteIds.contains(camp['id']),
                          );
                        },
                        childCount: filteredCamps.length,
                      ),
                    ),

              // Bottom spacing
              SliverToBoxAdapter(
                child: SizedBox(height: 10.h),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToListCamp,
        icon: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
        label: Text(
          'List a Camp',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
      ),
    );
  }
}
