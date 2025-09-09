import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/camp_storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import '../find_camps_screen/widgets/camp_card_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final CampStorageService _campService = CampStorageService();
  List<Map<String, dynamic>> _camps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCamps();
  }

  Future<void> _loadCamps() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _campService.initialize();
      final camps = _campService.getAllCamps();

      setState(() {
        _camps = camps;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Health Camps Map'),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showMapLegend,
            icon: CustomIconWidget(
              iconName: 'info',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
          IconButton(
            onPressed: _refreshCamps,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
      ),
      body:
          _isLoading
              ? _buildLoadingState()
              : _camps.isEmpty
              ? _buildEmptyState()
              : _buildMapView(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading map view...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'map',
              color: AppTheme.lightTheme.colorScheme.primary.withValues(
                alpha: 0.5,
              ),
              size: 20.w,
            ),
            SizedBox(height: 3.h),
            Text(
              'No Health Camps Found',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'There are no health camps available to show on the map at this time.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to List Camp screen
                DefaultTabController.of(context)?.animateTo(0);
              },
              icon: CustomIconWidget(
                iconName: 'add_circle',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 5.w,
              ),
              label: const Text('Add New Camp'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView() {
    return Column(
      children: [
        // Map View Placeholder
        Expanded(
          flex: 2,
          child: Container(
            margin: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline.withValues(
                  alpha: 0.3,
                ),
              ),
            ),
            child: Stack(
              children: [
                // Map placeholder
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'map',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 15.w,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Interactive Map View',
                        style: AppTheme.lightTheme.textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        '${_camps.length} health camps in your area',
                        style: AppTheme.lightTheme.textTheme.bodyMedium
                            ?.copyWith(
                              color:
                                  AppTheme
                                      .lightTheme
                                      .colorScheme
                                      .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                // Map controls
                Positioned(
                  top: 2.h,
                  right: 4.w,
                  child: Column(
                    children: [
                      _buildMapControl('my_location', 'My Location'),
                      SizedBox(height: 1.h),
                      _buildMapControl('zoom_in', 'Zoom In'),
                      SizedBox(height: 1.h),
                      _buildMapControl('zoom_out', 'Zoom Out'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Camps List
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nearby Health Camps',
                      style: AppTheme.lightTheme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${_camps.length} camps',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Expanded(
                  child: ListView.builder(
                    itemCount: _camps.length,
                    itemBuilder: (context, index) {
                      final camp = _camps[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 2.h),
                        child: CampCardWidget(
                          camp: camp,
                          onTap: () => _navigateToCampDetails(camp),
                          onFavorite: () => _toggleFavorite(camp),
                          onShare: () => _shareCamp(camp),
                          onDirections: () => _getDirections(camp),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapControl(String iconName, String tooltip) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow.withValues(
              alpha: 0.1,
            ),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleMapControl(iconName),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.all(2.w),
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
          ),
        ),
      ),
    );
  }

  void _handleMapControl(String action) {
    String message = '';
    switch (action) {
      case 'my_location':
        message = 'Centering map on your location...';
        break;
      case 'zoom_in':
        message = 'Zooming in...';
        break;
      case 'zoom_out':
        message = 'Zooming out...';
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showMapLegend() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Map Legend'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLegendItem(
                  'location_on',
                  'Available Camp',
                  AppTheme.lightTheme.colorScheme.primary,
                ),
                _buildLegendItem(
                  'location_on',
                  'Limited Availability',
                  Colors.orange,
                ),
                _buildLegendItem('location_on', 'Full Capacity', Colors.red),
                _buildLegendItem(
                  'my_location',
                  'Your Location',
                  AppTheme.lightTheme.colorScheme.secondary,
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

  Widget _buildLegendItem(String iconName, String label, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          CustomIconWidget(iconName: iconName, color: color, size: 5.w),
          SizedBox(width: 2.w),
          Text(label, style: AppTheme.lightTheme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Future<void> _refreshCamps() async {
    await _loadCamps();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Map updated'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _navigateToCampDetails(Map<String, dynamic> camp) {
    Navigator.pushNamed(context, '/camp-details-screen', arguments: camp);
  }

  Future<void> _toggleFavorite(Map<String, dynamic> camp) async {
    await _campService.toggleFavorite(camp['id'] as int);
    _loadCamps();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          camp['isFavorite'] == true
              ? 'Removed from favorites'
              : 'Added to favorites',
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _shareCamp(Map<String, dynamic> camp) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${camp['name']}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _getDirections(Map<String, dynamic> camp) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening directions to ${camp['location']}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }
}