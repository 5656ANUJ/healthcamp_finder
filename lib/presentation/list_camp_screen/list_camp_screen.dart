import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/camp_storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/camp_form_widget.dart';
import './widgets/location_picker_widget.dart';
import './widgets/photo_upload_widget.dart';

class ListCampScreen extends StatefulWidget {
  const ListCampScreen({Key? key}) : super(key: key);

  @override
  State<ListCampScreen> createState() => _ListCampScreenState();
}

class _ListCampScreenState extends State<ListCampScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController();
  final CampStorageService _campService = CampStorageService();

  // Form data storage
  Map<String, dynamic> _formData = {};
  Map<String, dynamic> _locationData = {};
  List<XFile> _photos = [];

  bool _isPublishing = false;
  bool _isDraftSaved = false;
  int _currentStep = 0;

  final List<String> _stepTitles = ['Camp Details', 'Location', 'Photos'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadDraftData();
    _initializeCampService();
  }

  Future<void> _initializeCampService() async {
    await _campService.initialize();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentStep = _tabController.index;
      });
      _pageController.animateToPage(
        _tabController.index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _loadDraftData() {
    // Mock draft data loading
    setState(() {
      _formData = {
        'campName': '',
        'description': '',
        'category': 'General Health',
        'date': null,
        'time': null,
        'organizerName': '',
        'phone': '',
        'email': '',
        'whatsapp': '',
        'capacity': '',
        'specialRequirements': '',
      };
      _locationData = {
        'address': '',
        'city': '',
        'state': '',
        'zipCode': '',
        'latitude': null,
        'longitude': null,
      };
    });
  }

  void _saveDraft() {
    // Mock draft saving
    setState(() {
      _isDraftSaved = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Draft saved successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );

    // Reset draft saved status after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isDraftSaved = false;
        });
      }
    });
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0: // Camp Details
        if (_formData['campName']?.isEmpty ?? true) {
          _showValidationError('Please enter camp name');
          return false;
        }
        if (_formData['description']?.isEmpty ?? true) {
          _showValidationError('Please enter camp description');
          return false;
        }
        if (_formData['date'] == null) {
          _showValidationError('Please select camp date');
          return false;
        }
        if (_formData['time'] == null) {
          _showValidationError('Please select camp time');
          return false;
        }
        if (_formData['organizerName']?.isEmpty ?? true) {
          _showValidationError('Please enter organizer name');
          return false;
        }
        if (_formData['phone']?.isEmpty ?? true) {
          _showValidationError('Please enter phone number');
          return false;
        }
        if (_formData['email']?.isEmpty ?? true) {
          _showValidationError('Please enter email address');
          return false;
        }
        return true;
      case 1: // Location
        if (_locationData['address']?.isEmpty ?? true) {
          _showValidationError('Please enter street address');
          return false;
        }
        if (_locationData['city']?.isEmpty ?? true) {
          _showValidationError('Please enter city');
          return false;
        }
        if (_locationData['state']?.isEmpty ?? true) {
          _showValidationError('Please enter state');
          return false;
        }
        return true;
      case 2: // Photos
        return true; // Photos are optional
      default:
        return true;
    }
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
      ),
    );
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < 2) {
        setState(() {
          _currentStep++;
        });
        _tabController.animateTo(_currentStep);
      } else {
        _publishCamp();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _tabController.animateTo(_currentStep);
    }
  }

  Future<void> _publishCamp() async {
    if (!_validateAllSteps()) return;

    setState(() {
      _isPublishing = true;
    });

    try {
      // Create camp data object
      final campData = {
        'name': _formData['campName'],
        'description': _formData['description'],
        'date': _formData['date']?.toString() ?? '',
        'time': _formData['time']?.toString() ?? '',
        'location':
            _locationData['address'] != null
                ? '${_locationData['address']}, ${_locationData['city']}, ${_locationData['state']}'
                : 'Location not specified',
        'distance': '0.0', // Default distance
        'type': _formData['category'] ?? 'General Health',
        'availability': 'Available',
        'organizer': _formData['organizerName'] ?? 'Unknown',
        'contact': _formData['phone'] ?? '',
        'image':
            'https://images.pexels.com/photos/4386467/pexels-photo-4386467.jpeg?auto=compress&cs=tinysrgb&w=800',
        'maxCapacity': int.tryParse(_formData['capacity'] ?? '50') ?? 50,
      };

      // Save camp to storage
      await _campService.addCamp(campData);

      // Show success dialog
      _showSuccessDialog();
    } catch (e) {
      _showError('Failed to publish camp. Please try again.');
    } finally {
      setState(() {
        _isPublishing = false;
      });
    }
  }

  bool _validateAllSteps() {
    final int previousStep = _currentStep;
    for (int i = 0; i < 3; i++) {
      setState(() {
        _currentStep = i;
      });
      if (!_validateCurrentStep()) {
        _tabController.animateTo(i);
        return false;
      }
    }
    setState(() {
      _currentStep = previousStep;
    });
    return true;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary.withValues(
                      alpha: 0.1,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 48,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Camp Published Successfully!',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Your health camp has been published and is now visible to users in the Find Camps section.',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _createAnotherCamp();
                },
                child: const Text('Create Another'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigate to Find Camps tab
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  // Switch to Find Camps tab (index 1)
                  DefaultTabController.of(context)?.animateTo(1);
                },
                child: const Text('View in Find Camps'),
              ),
            ],
          ),
    );
  }

  void _createAnotherCamp() {
    setState(() {
      _currentStep = 0;
      _formData = {
        'campName': '',
        'description': '',
        'category': 'General Health',
        'date': null,
        'time': null,
        'organizerName': _formData['organizerName'], // Keep organizer info
        'phone': _formData['phone'],
        'email': _formData['email'],
        'whatsapp': _formData['whatsapp'],
        'capacity': '',
        'specialRequirements': '',
      };
      _locationData = {
        'address': '',
        'city': '',
        'state': '',
        'zipCode': '',
        'latitude': null,
        'longitude': null,
      };
      _photos = [];
    });
    _tabController.animateTo(0);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Create Health Camp'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: _saveDraft,
            icon: CustomIconWidget(
              iconName: _isDraftSaved ? 'check' : 'save',
              color:
                  _isDraftSaved
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 18,
            ),
            label: Text(
              _isDraftSaved ? 'Saved' : 'Save Draft',
              style: TextStyle(
                color:
                    _isDraftSaved
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs:
              _stepTitles.asMap().entries.map((entry) {
                final index = entry.key;
                final title = entry.value;
                return Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              _currentStep >= index
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme.lightTheme.colorScheme.outline,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color:
                                  _currentStep >= index
                                      ? AppTheme
                                          .lightTheme
                                          .colorScheme
                                          .onPrimary
                                      : AppTheme
                                          .lightTheme
                                          .colorScheme
                                          .onSurfaceVariant,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight:
                                _currentStep == index
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ),
      body: Column(
        children: [
          // Progress Indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / 3,
              backgroundColor: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.lightTheme.primaryColor,
              ),
            ),
          ),

          // Form Content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
                _tabController.animateTo(index);
              },
              children: [
                // Step 1: Camp Form
                CampFormWidget(
                  formData: _formData,
                  onFormChanged: (data) {
                    setState(() {
                      _formData = data;
                    });
                  },
                ),

                // Step 2: Location Picker
                LocationPickerWidget(
                  initialLocation: _locationData,
                  onLocationSelected: (data) {
                    setState(() {
                      _locationData = data;
                    });
                  },
                ),

                // Step 3: Photo Upload
                PhotoUploadWidget(
                  initialPhotos: _photos,
                  onPhotosChanged: (photos) {
                    setState(() {
                      _photos = photos;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              if (_currentStep > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousStep,
                    child: const Text('Previous'),
                  ),
                ),
              if (_currentStep > 0) SizedBox(width: 4.w),
              Expanded(
                flex: _currentStep == 0 ? 1 : 1,
                child: ElevatedButton(
                  onPressed: _isPublishing ? null : _nextStep,
                  child:
                      _isPublishing
                          ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.lightTheme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                          : Text(_currentStep == 2 ? 'Publish Camp' : 'Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
