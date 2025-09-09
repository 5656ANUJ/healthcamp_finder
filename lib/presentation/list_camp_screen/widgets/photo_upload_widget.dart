import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhotoUploadWidget extends StatefulWidget {
  final Function(List<XFile>) onPhotosChanged;
  final List<XFile> initialPhotos;

  const PhotoUploadWidget({
    Key? key,
    required this.onPhotosChanged,
    this.initialPhotos = const [],
  }) : super(key: key);

  @override
  State<PhotoUploadWidget> createState() => _PhotoUploadWidgetState();
}

class _PhotoUploadWidgetState extends State<PhotoUploadWidget> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedPhotos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedPhotos = List.from(widget.initialPhotos);
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true; // Browser handles permissions

    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> _requestStoragePermission() async {
    if (kIsWeb) return true; // Browser handles permissions

    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true; // iOS handles automatically
  }

  Future<void> _pickImageFromCamera() async {
    try {
      setState(() => _isLoading = true);

      final hasPermission = await _requestCameraPermission();
      if (!hasPermission) {
        _showPermissionError('Camera permission is required to take photos');
        setState(() => _isLoading = false);
        return;
      }

      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() {
          _selectedPhotos.add(photo);
        });
        widget.onPhotosChanged(_selectedPhotos);
      }
    } catch (e) {
      _showError('Failed to capture photo. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      setState(() => _isLoading = true);

      final hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        _showPermissionError('Storage permission is required to access photos');
        setState(() => _isLoading = false);
        return;
      }

      final List<XFile> photos = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photos.isNotEmpty) {
        setState(() {
          _selectedPhotos.addAll(photos);
          // Limit to maximum 5 photos
          if (_selectedPhotos.length > 5) {
            _selectedPhotos = _selectedPhotos.take(5).toList();
            _showError('Maximum 5 photos allowed');
          }
        });
        widget.onPhotosChanged(_selectedPhotos);
      }
    } catch (e) {
      _showError('Failed to select photos. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _selectedPhotos.removeAt(index);
    });
    widget.onPhotosChanged(_selectedPhotos);
  }

  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
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
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Add Photo',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImagePickerOption(
                  icon: 'camera_alt',
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromCamera();
                  },
                ),
                _buildImagePickerOption(
                  icon: 'photo_library',
                  label: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromGallery();
                  },
                ),
              ],
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerOption({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.primaryColor,
              size: 32,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPermissionError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        action: SnackBarAction(
          label: 'Settings',
          textColor: AppTheme.lightTheme.colorScheme.onError,
          onPressed: () => openAppSettings(),
        ),
      ),
    );
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
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Photos',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              Text(
                '${_selectedPhotos.length}/5',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Photo Grid
          if (_selectedPhotos.isNotEmpty) ...[
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2.w,
                mainAxisSpacing: 2.w,
                childAspectRatio: 1,
              ),
              itemCount: _selectedPhotos.length,
              itemBuilder: (context, index) {
                return _buildPhotoItem(_selectedPhotos[index], index);
              },
            ),
            SizedBox(height: 2.h),
          ],

          // Add Photo Button
          if (_selectedPhotos.length < 5)
            InkWell(
              onTap: _isLoading ? null : _showImagePickerBottomSheet,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                height: 15.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.lightTheme.primaryColor,
                    style: BorderStyle.solid,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLoading)
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.primaryColor,
                        ),
                      )
                    else ...[
                      CustomIconWidget(
                        iconName: 'add_photo_alternate',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 32,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Add Photos',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Upload camp photos to attract participants',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),

          if (_selectedPhotos.length >= 5)
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
                      'Maximum 5 photos allowed. Remove a photo to add more.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPhotoItem(XFile photo, int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: kIsWeb
                ? Image.network(
                    photo.path,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        child: Center(
                          child: CustomIconWidget(
                            iconName: 'broken_image',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                        ),
                      );
                    },
                  )
                : Image.file(
                    File(photo.path),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        child: Center(
                          child: CustomIconWidget(
                            iconName: 'broken_image',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
        Positioned(
          top: 1.w,
          right: 1.w,
          child: InkWell(
            onTap: () => _removePhoto(index),
            child: Container(
              padding: EdgeInsets.all(1.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.error,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.lightTheme.colorScheme.onError,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
