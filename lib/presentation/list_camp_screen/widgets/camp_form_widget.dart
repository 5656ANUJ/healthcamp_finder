import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CampFormWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onFormChanged;
  final Map<String, dynamic> formData;

  const CampFormWidget({
    Key? key,
    required this.onFormChanged,
    required this.formData,
  }) : super(key: key);

  @override
  State<CampFormWidget> createState() => _CampFormWidgetState();
}

class _CampFormWidgetState extends State<CampFormWidget> {
  final TextEditingController _campNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _organizerNameController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _specialRequirementsController =
      TextEditingController();

  String _selectedCategory = 'General Health';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _showAdvancedOptions = false;

  final List<String> _categories = [
    'General Health',
    'Cardiology',
    'Diabetes',
    'Eye Care',
    'Dental',
    'Women\'s Health',
    'Child Health',
    'Mental Health',
    'Orthopedic',
    'Dermatology'
  ];

  @override
  void initState() {
    super.initState();
    _initializeFormData();
  }

  void _initializeFormData() {
    _campNameController.text = widget.formData['campName'] ?? '';
    _descriptionController.text = widget.formData['description'] ?? '';
    _organizerNameController.text = widget.formData['organizerName'] ?? '';
    _phoneController.text = widget.formData['phone'] ?? '';
    _emailController.text = widget.formData['email'] ?? '';
    _whatsappController.text = widget.formData['whatsapp'] ?? '';
    _capacityController.text = widget.formData['capacity'] ?? '';
    _specialRequirementsController.text =
        widget.formData['specialRequirements'] ?? '';
    _selectedCategory = widget.formData['category'] ?? 'General Health';
    _selectedDate = widget.formData['date'];
    _selectedTime = widget.formData['time'];
  }

  void _updateFormData() {
    final updatedData = {
      'campName': _campNameController.text,
      'description': _descriptionController.text,
      'category': _selectedCategory,
      'date': _selectedDate,
      'time': _selectedTime,
      'organizerName': _organizerNameController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'whatsapp': _whatsappController.text,
      'capacity': _capacityController.text,
      'specialRequirements': _specialRequirementsController.text,
    };
    widget.onFormChanged(updatedData);
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.lightTheme.primaryColor,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _updateFormData();
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.lightTheme.primaryColor,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      _updateFormData();
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Camp Name Section
          _buildSectionTitle('Camp Details'),
          SizedBox(height: 2.h),
          _buildTextField(
            controller: _campNameController,
            label: 'Camp Name',
            hint: 'Enter health camp name',
            maxLength: 100,
            onChanged: (value) => _updateFormData(),
          ),
          SizedBox(height: 2.h),

          // Description Section
          _buildTextField(
            controller: _descriptionController,
            label: 'Description',
            hint: 'Describe the health camp services and objectives',
            maxLines: 4,
            maxLength: 500,
            onChanged: (value) => _updateFormData(),
          ),
          SizedBox(height: 3.h),

          // Category Section
          _buildSectionTitle('Category'),
          SizedBox(height: 2.h),
          _buildCategoryChips(),
          SizedBox(height: 3.h),

          // Date & Time Section
          _buildSectionTitle('Schedule'),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildDateTimeSelector(
                  label: 'Date',
                  value: _selectedDate != null
                      ? _formatDate(_selectedDate!)
                      : 'Select Date',
                  onTap: _selectDate,
                  icon: 'calendar_today',
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildDateTimeSelector(
                  label: 'Time',
                  value: _selectedTime != null
                      ? _formatTime(_selectedTime!)
                      : 'Select Time',
                  onTap: _selectTime,
                  icon: 'access_time',
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Contact Details Section
          _buildSectionTitle('Contact Information'),
          SizedBox(height: 2.h),
          _buildTextField(
            controller: _organizerNameController,
            label: 'Organizer Name',
            hint: 'Enter organizer full name',
            onChanged: (value) => _updateFormData(),
          ),
          SizedBox(height: 2.h),
          _buildTextField(
            controller: _phoneController,
            label: 'Phone Number',
            hint: '+1 (555) 123-4567',
            keyboardType: TextInputType.phone,
            onChanged: (value) => _updateFormData(),
          ),
          SizedBox(height: 2.h),
          _buildTextField(
            controller: _emailController,
            label: 'Email Address',
            hint: 'organizer@example.com',
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => _updateFormData(),
          ),
          SizedBox(height: 2.h),
          _buildTextField(
            controller: _whatsappController,
            label: 'WhatsApp Number',
            hint: '+1 (555) 123-4567',
            keyboardType: TextInputType.phone,
            onChanged: (value) => _updateFormData(),
          ),
          SizedBox(height: 3.h),

          // Advanced Options
          _buildAdvancedOptionsToggle(),
          if (_showAdvancedOptions) ...[
            SizedBox(height: 2.h),
            _buildTextField(
              controller: _capacityController,
              label: 'Capacity Limit',
              hint: 'Maximum number of participants',
              keyboardType: TextInputType.number,
              onChanged: (value) => _updateFormData(),
            ),
            SizedBox(height: 2.h),
            _buildTextField(
              controller: _specialRequirementsController,
              label: 'Special Requirements',
              hint: 'Any special requirements or instructions',
              maxLines: 3,
              onChanged: (value) => _updateFormData(),
            ),
          ],
          SizedBox(height: 4.h),
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
    int maxLines = 1,
    int? maxLength,
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
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            counterText: maxLength != null
                ? '${controller.text.length}/$maxLength'
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: _categories.map((category) {
        final isSelected = _selectedCategory == category;
        return FilterChip(
          label: Text(
            category,
            style: TextStyle(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.onPrimary
                  : AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedCategory = category;
              });
              _updateFormData();
            }
          },
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          selectedColor: AppTheme.lightTheme.primaryColor,
          checkmarkColor: AppTheme.lightTheme.colorScheme.onPrimary,
          side: BorderSide(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.outline,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDateTimeSelector({
    required String label,
    required String value,
    required VoidCallback onTap,
    required String icon,
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
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(12),
              color: AppTheme.lightTheme.colorScheme.surface,
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: icon,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    value,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: value.contains('Select')
                          ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          : AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedOptionsToggle() {
    return InkWell(
      onTap: () {
        setState(() {
          _showAdvancedOptions = !_showAdvancedOptions;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: _showAdvancedOptions ? 'expand_less' : 'expand_more',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              'Advanced Options',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _campNameController.dispose();
    _descriptionController.dispose();
    _organizerNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _whatsappController.dispose();
    _capacityController.dispose();
    _specialRequirementsController.dispose();
    super.dispose();
  }
}
