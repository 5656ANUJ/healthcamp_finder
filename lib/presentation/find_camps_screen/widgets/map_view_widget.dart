import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MapViewWidget extends StatefulWidget {
  final List<Map<String, dynamic>> camps;
  final Function(Map<String, dynamic>) onCampTap;

  const MapViewWidget({
    Key? key,
    required this.camps,
    required this.onCampTap,
  }) : super(key: key);

  @override
  State<MapViewWidget> createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends State<MapViewWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Map<String, dynamic>? _selectedCamp;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194), // San Francisco coordinates
    zoom: 12.0,
  );

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  @override
  void didUpdateWidget(MapViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.camps != widget.camps) {
      _createMarkers();
    }
  }

  void _createMarkers() {
    _markers.clear();

    for (int i = 0; i < widget.camps.length; i++) {
      final camp = widget.camps[i];
      final markerId = MarkerId('camp_${camp['id']}');

      // Generate coordinates around San Francisco for demo
      final lat = 37.7749 + (i * 0.01) - 0.05;
      final lng = -122.4194 + (i * 0.01) - 0.05;

      _markers.add(
        Marker(
          markerId: markerId,
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _getMarkerColor(camp['availability'] as String? ?? 'Available'),
          ),
          infoWindow: InfoWindow(
            title: camp['name'] as String? ?? 'Health Camp',
            snippet: camp['location'] as String? ?? 'Location TBD',
            onTap: () => _showCampPreview(camp),
          ),
          onTap: () => _showCampPreview(camp),
        ),
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  double _getMarkerColor(String availability) {
    switch (availability.toLowerCase()) {
      case 'full':
        return BitmapDescriptor.hueRed;
      case 'limited':
        return BitmapDescriptor.hueOrange;
      default:
        return BitmapDescriptor.hueGreen;
    }
  }

  void _showCampPreview(Map<String, dynamic> camp) {
    setState(() {
      _selectedCamp = camp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _initialPosition,
          markers: _markers,
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
          onTap: (_) {
            setState(() {
              _selectedCamp = null;
            });
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
        ),
        _buildMyLocationButton(),
        if (_selectedCamp != null) _buildCampPreviewCard(),
      ],
    );
  }

  Widget _buildMyLocationButton() {
    return Positioned(
      bottom: 20.h,
      right: 4.w,
      child: FloatingActionButton(
        mini: true,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        foregroundColor: AppTheme.lightTheme.colorScheme.primary,
        onPressed: _goToCurrentLocation,
        child: CustomIconWidget(
          iconName: 'my_location',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 6.w,
        ),
      ),
    );
  }

  Widget _buildCampPreviewCard() {
    return Positioned(
      bottom: 2.h,
      left: 4.w,
      right: 4.w,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomImageWidget(
                    imageUrl: _selectedCamp!['image'] as String? ?? '',
                    width: 20.w,
                    height: 15.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedCamp!['name'] as String? ?? 'Health Camp',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      _buildPreviewInfoRow(
                        'location_on',
                        _selectedCamp!['location'] as String? ?? 'Location TBD',
                      ),
                      SizedBox(height: 0.5.h),
                      _buildPreviewInfoRow(
                        'schedule',
                        _selectedCamp!['date'] as String? ?? 'TBD',
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _selectedCamp = null),
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: _getAvailabilityColor(
                            _selectedCamp!['availability'] as String? ??
                                'Available')
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _selectedCamp!['availability'] as String? ?? 'Available',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: _getAvailabilityColor(
                          _selectedCamp!['availability'] as String? ??
                              'Available'),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => widget.onCampTap(_selectedCamp!),
                  child: Text('View Details'),
                ),
                SizedBox(width: 2.w),
                ElevatedButton.icon(
                  onPressed: () => _getDirections(_selectedCamp!),
                  icon: CustomIconWidget(
                    iconName: 'directions',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 4.w,
                  ),
                  label: Text('Directions'),
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewInfoRow(String iconName, String text) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 3.5.w,
        ),
        SizedBox(width: 1.w),
        Expanded(
          child: Text(
            text,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getAvailabilityColor(String availability) {
    switch (availability.toLowerCase()) {
      case 'full':
        return AppTheme.lightTheme.colorScheme.error;
      case 'limited':
        return const Color(0xFFF66A0A);
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  void _goToCurrentLocation() {
    // Simulate moving to current location
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(
          target: LatLng(37.7849, -122.4094),
          zoom: 14.0,
        ),
      ),
    );
  }

  void _getDirections(Map<String, dynamic> camp) {
    // This would typically open a maps app or show directions
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening directions to ${camp['name']}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
