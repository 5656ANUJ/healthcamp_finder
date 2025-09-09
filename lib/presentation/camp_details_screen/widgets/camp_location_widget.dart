import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CampLocationWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String locationName;

  const CampLocationWidget({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.locationName,
  }) : super(key: key);

  @override
  State<CampLocationWidget> createState() => _CampLocationWidgetState();
}

class _CampLocationWidgetState extends State<CampLocationWidget> {
  GoogleMapController? _mapController;
  late Set<Marker> _markers;

  @override
  void initState() {
    super.initState();
    _markers = {
      Marker(
        markerId: const MarkerId('camp_location'),
        position: LatLng(widget.latitude, widget.longitude),
        infoWindow: InfoWindow(
          title: 'Health Camp Location',
          snippet: widget.locationName,
        ),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),

          // Location Address
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'location_on',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    widget.locationName,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),

          // Map Container
          Container(
            height: 25.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.latitude, widget.longitude),
                  zoom: 15.0,
                ),
                markers: _markers,
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                myLocationButtonEnabled: false,
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Get Directions Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _openDirections,
              icon: CustomIconWidget(
                iconName: 'directions',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              label: Text(
                'Get Directions',
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
      ),
    );
  }

  void _openDirections() {
    // This would open native maps app with directions
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening directions in maps app...')),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
