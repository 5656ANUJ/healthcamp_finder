import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterBottomSheetWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersApplied,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;
  DateTimeRange? _selectedDateRange;
  double _selectedDistance = 50.0;
  Set<String> _selectedCampTypes = {};
  bool _availableOnly = false;

  final List<Map<String, String>> _campTypes = [
    {'name': 'General Health', 'icon': 'medical_services'},
    {'name': 'Eye Care', 'icon': 'visibility'},
    {'name': 'Dental', 'icon': 'sentiment_satisfied'},
    {'name': 'Blood Donation', 'icon': 'bloodtype'},
    {'name': 'Vaccination', 'icon': 'vaccines'},
    {'name': 'Women\'s Health', 'icon': 'pregnant_woman'},
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
    _initializeFilters();
  }

  void _initializeFilters() {
    _selectedDistance = (_filters['distance'] as double?) ?? 50.0;
    _availableOnly = (_filters['availableOnly'] as bool?) ?? false;
    _selectedCampTypes =
        Set<String>.from((_filters['campTypes'] as List?) ?? []);

    if (_filters['dateRange'] != null) {
      final dateRange = _filters['dateRange'] as Map<String, DateTime>;
      _selectedDateRange = DateTimeRange(
        start: dateRange['start']!,
        end: dateRange['end']!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateRangeSection(),
                  SizedBox(height: 3.h),
                  _buildDistanceSection(),
                  SizedBox(height: 3.h),
                  _buildCampTypeSection(),
                  SizedBox(height: 3.h),
                  _buildAvailabilitySection(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'tune',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 6.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'Filter Health Camps',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeSection() {
    return _buildFilterSection(
      title: 'Date Range',
      icon: 'date_range',
      child: GestureDetector(
        onTap: _selectDateRange,
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'calendar_today',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  _selectedDateRange != null
                      ? '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}'
                      : 'Select date range',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: _selectedDateRange != null
                        ? AppTheme.lightTheme.colorScheme.onSurface
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              if (_selectedDateRange != null)
                GestureDetector(
                  onTap: () => setState(() => _selectedDateRange = null),
                  child: CustomIconWidget(
                    iconName: 'clear',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDistanceSection() {
    return _buildFilterSection(
      title: 'Distance',
      icon: 'near_me',
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Within ${_selectedDistance.round()} km',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${_selectedDistance.round()} km',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.lightTheme.colorScheme.primary,
              thumbColor: AppTheme.lightTheme.colorScheme.primary,
              overlayColor: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
              inactiveTrackColor: AppTheme.lightTheme.colorScheme.outline,
            ),
            child: Slider(
              value: _selectedDistance,
              min: 1.0,
              max: 100.0,
              divisions: 99,
              onChanged: (value) => setState(() => _selectedDistance = value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampTypeSection() {
    return _buildFilterSection(
      title: 'Camp Type',
      icon: 'category',
      child: Wrap(
        spacing: 2.w,
        runSpacing: 1.h,
        children: _campTypes.map((type) => _buildCampTypeChip(type)).toList(),
      ),
    );
  }

  Widget _buildCampTypeChip(Map<String, String> type) {
    final isSelected = _selectedCampTypes.contains(type['name']);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedCampTypes.remove(type['name']);
          } else {
            _selectedCampTypes.add(type['name']!);
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: type['icon']!,
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.onPrimary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text(
              type['name']!,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilitySection() {
    return _buildFilterSection(
      title: 'Availability',
      icon: 'event_available',
      child: SwitchListTile(
        title: Text(
          'Show only available camps',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        subtitle: Text(
          'Hide camps that are full',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        value: _availableOnly,
        onChanged: (value) => setState(() => _availableOnly = value),
        activeColor: AppTheme.lightTheme.colorScheme.primary,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required String icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        child,
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _clearFilters,
              child: Text('Clear All'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _applyFilters,
              child: Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  void _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.lightTheme.colorScheme.primary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDateRange = picked);
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedDateRange = null;
      _selectedDistance = 50.0;
      _selectedCampTypes.clear();
      _availableOnly = false;
    });
  }

  void _applyFilters() {
    final filters = <String, dynamic>{
      'dateRange': _selectedDateRange != null
          ? {
              'start': _selectedDateRange!.start,
              'end': _selectedDateRange!.end,
            }
          : null,
      'distance': _selectedDistance,
      'campTypes': _selectedCampTypes.toList(),
      'availableOnly': _availableOnly,
    };

    widget.onFiltersApplied(filters);
    Navigator.pop(context);
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
