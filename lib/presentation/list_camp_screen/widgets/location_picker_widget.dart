import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationPickerWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onLocationSelected;
  final Map<String, dynamic>? initialLocation;

  const LocationPickerWidget({
    Key? key,
    required this.onLocationSelected,
    this.initialLocation,
  }) : super(key: key);

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  GoogleMapController? _mapController;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  LatLng _selectedLocation =
      const LatLng(37.7749, -122.4194); // Default to San Francisco
  Set<Marker> _markers = {};
  bool _isLoadingLocation = false;
  bool _showMap = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  void _initializeLocation() {
    if (widget.initialLocation != null) {
      _addressController.text = widget.initialLocation!['address'] ?? '';
      _cityController.text = widget.initialLocation!['city'] ?? '';
      _stateController.text = widget.initialLocation!['state'] ?? '';
      _zipController.text = widget.initialLocation!['zipCode'] ?? '';

      if (widget.initialLocation!['latitude'] != null &&
          widget.initialLocation!['longitude'] != null) {
        _selectedLocation = LatLng(
          widget.initialLocation!['latitude'],
          widget.initialLocation!['longitude'],
        );
        _updateMarker();
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    if (kIsWeb) {
      // Web implementation using browser geolocation
      try {
        setState(() => _isLoadingLocation = true);

        // For web, we'll use a default location or implement browser geolocation
        _selectedLocation = const LatLng(37.7749, -122.4194);
        _updateMarker();
        _updateLocationData();

        setState(() => _isLoadingLocation = false);
      } catch (e) {
        setState(() => _isLoadingLocation = false);
        _showLocationError('Unable to get current location on web');
      }
    } else {
      // Mobile implementation
      try {
        setState(() => _isLoadingLocation = true);

        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          setState(() => _isLoadingLocation = false);
          _showLocationError('Location services are disabled');
          return;
        }

        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            setState(() => _isLoadingLocation = false);
            _showLocationError('Location permissions are denied');
            return;
          }
        }

        if (permission == LocationPermission.deniedForever) {
          setState(() => _isLoadingLocation = false);
          _showLocationError('Location permissions are permanently denied');
          return;
        }

        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        _selectedLocation = LatLng(position.latitude, position.longitude);
        _updateMarker();
        _updateLocationData();

        setState(() => _isLoadingLocation = false);
      } catch (e) {
        setState(() => _isLoadingLocation = false);
        _showLocationError('Unable to get current location');
      }
    }
  }

  void _updateMarker() {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('selected_location'),
          position: _selectedLocation,
          infoWindow: const InfoWindow(title: 'Camp Location'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      };
    });
  }

  void _updateLocationData() {
    final locationData = {
      'address': _addressController.text,
      'city': _cityController.text,
      'state': _stateController.text,
      'zipCode': _zipController.text,
      'latitude': _selectedLocation.latitude,
      'longitude': _selectedLocation.longitude,
    };
    widget.onLocationSelected(locationData);
  }

  void _showLocationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
      ),
    );
  }

  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
    _updateMarker();
    _updateLocationData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Location Details'),
          SizedBox(height: 2.h),

          // Address Fields
          _buildTextField(
            controller: _addressController,
            label: 'Street Address',
            hint: '123 Main Street',
            onChanged: (value) => _updateLocationData(),
          ),
          SizedBox(height: 2.h),

          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildTextField(
                  controller: _cityController,
                  label: 'City',
                  hint: 'San Francisco',
                  onChanged: (value) => _updateLocationData(),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildTextField(
                  controller: _stateController,
                  label: 'State',
                  hint: 'CA',
                  onChanged: (value) => _updateLocationData(),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          _buildTextField(
            controller: _zipController,
            label: 'ZIP Code',
            hint: '94102',
            keyboardType: TextInputType.number,
            onChanged: (value) => _updateLocationData(),
          ),
          SizedBox(height: 3.h),

          // Location Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                  icon: _isLoadingLocation
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.primaryColor,
                            ),
                          ),
                        )
                      : CustomIconWidget(
                          iconName: 'my_location',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 18,
                        ),
                  label: Text(_isLoadingLocation
                      ? 'Getting Location...'
                      : 'Use Current Location'),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showMap = !_showMap;
                    });
                  },
                  icon: CustomIconWidget(
                    iconName: _showMap ? 'map' : 'map',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 18,
                  ),
                  label: Text(_showMap ? 'Hide Map' : 'Show Map'),
                ),
              ),
            ],
          ),

          // Map View
          if (_showMap) ...[
            SizedBox(height: 3.h),
            Container(
              height: 40.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation,
                    zoom: 15.0,
                  ),
                  markers: _markers,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  onTap: _onMapTap,
                  myLocationEnabled: !kIsWeb,
                  myLocationButtonEnabled: !kIsWeb,
                  zoomControlsEnabled: true,
                  mapToolbarEnabled: false,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Tap on the map to select the exact camp location',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppTheme.lightTheme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _mapController?.dispose();
    super.dispose();
  }
}
