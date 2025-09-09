import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/camp_storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/camp_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/map_view_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/view_toggle_widget.dart';

class FindCampsScreen extends StatefulWidget {
  const FindCampsScreen({Key? key}) : super(key: key);

  @override
  State<FindCampsScreen> createState() => _FindCampsScreenState();
}

class _FindCampsScreenState extends State<FindCampsScreen> {
  ViewType _selectedView = ViewType.list;
  String _searchQuery = '';
  Map<String, dynamic> _appliedFilters = {};
  List<Map<String, dynamic>> _filteredCamps = [];
  List<Map<String, dynamic>> _allCamps = [];
  bool _isLoading = false;

  final CampStorageService _campService = CampStorageService();

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
        _allCamps = camps;
        _filteredCamps = List.from(camps);
        _isLoading = false;
      });

      _applyFilters();
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
        title: const Text('Find Health Camps'),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
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
      body: SafeArea(
        child: Column(
          children: [
            SearchBarWidget(
              onSearchChanged: _onSearchChanged,
              onFilterTap: _showFilterBottomSheet,
              filterCount: _getActiveFilterCount(),
            ),
            if (_appliedFilters.isNotEmpty)
              FilterChipsWidget(
                appliedFilters: _appliedFilters,
                onChipRemoved: _removeFilter,
                onClearAll: _clearAllFilters,
              ),
            ViewToggleWidget(
              selectedView: _selectedView,
              onViewChanged: _onViewChanged,
            ),
            Expanded(
              child:
                  _isLoading
                      ? _buildLoadingState()
                      : _filteredCamps.isEmpty
                      ? _buildEmptyState()
                      : _selectedView == ViewType.list
                      ? _buildListView()
                      : _buildMapView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return RefreshIndicator(
      onRefresh: _refreshCamps,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 2.h),
        itemCount: _filteredCamps.length,
        itemBuilder: (context, index) {
          final camp = _filteredCamps[index];
          return CampCardWidget(
            camp: camp,
            onTap: () => _navigateToCampDetails(camp),
            onFavorite: () => _toggleFavorite(camp),
            onShare: () => _shareCamp(camp),
            onDirections: () => _getDirections(camp),
          );
        },
      ),
    );
  }

  Widget _buildMapView() {
    return MapViewWidget(
      camps: _filteredCamps,
      onCampTap: _navigateToCampDetails,
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
            'Finding health camps near you...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    if (_searchQuery.isNotEmpty || _appliedFilters.isNotEmpty) {
      return EmptyStateWidget(
        title: 'No camps found',
        subtitle:
            'Try adjusting your search criteria or filters to find more health camps in your area.',
        iconName: 'search_off',
        onAction: _clearAllFilters,
        actionText: 'Clear Filters',
      );
    } else {
      return EmptyStateWidget(
        title: 'No health camps available',
        subtitle:
            'There are currently no health camps scheduled in your area. Check back later or expand your search radius.',
        iconName: 'medical_services',
        onAction: () => _showFilterBottomSheet(),
        actionText: 'Adjust Filters',
      );
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _onViewChanged(ViewType viewType) {
    setState(() {
      _selectedView = viewType;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => FilterBottomSheetWidget(
            currentFilters: _appliedFilters,
            onFiltersApplied: _onFiltersApplied,
          ),
    );
  }

  void _onFiltersApplied(Map<String, dynamic> filters) {
    setState(() {
      _appliedFilters = filters;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allCamps);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = _campService.searchCamps(_searchQuery);
    }

    // Apply date range filter
    if (_appliedFilters['dateRange'] != null) {
      // For demo purposes, we'll keep all camps as date filtering would require proper date parsing
    }

    // Apply distance filter
    if (_appliedFilters['distance'] != null) {
      final maxDistance = _appliedFilters['distance'] as double;
      filtered =
          filtered.where((camp) {
            final distance = double.tryParse(camp['distance'] as String) ?? 0.0;
            return distance <= maxDistance;
          }).toList();
    }

    // Apply camp type filter
    if (_appliedFilters['campTypes'] != null &&
        (_appliedFilters['campTypes'] as List).isNotEmpty) {
      final selectedTypes = _appliedFilters['campTypes'] as List<String>;
      filtered =
          filtered.where((camp) {
            return selectedTypes.contains(camp['type'] as String);
          }).toList();
    }

    // Apply availability filter
    if (_appliedFilters['availableOnly'] == true) {
      filtered =
          filtered.where((camp) {
            return (camp['availability'] as String).toLowerCase() != 'full';
          }).toList();
    }

    setState(() {
      _filteredCamps = filtered;
    });
  }

  void _removeFilter(String key) {
    setState(() {
      if (key.startsWith('campType_')) {
        final type = key.substring(9);
        final campTypes = _appliedFilters['campTypes'] as List<String>?;
        if (campTypes != null) {
          campTypes.remove(type);
          if (campTypes.isEmpty) {
            _appliedFilters.remove('campTypes');
          }
        }
      } else {
        _appliedFilters.remove(key);
      }
      _applyFilters();
    });
  }

  void _clearAllFilters() {
    setState(() {
      _appliedFilters.clear();
      _searchQuery = '';
      _applyFilters();
    });
  }

  int _getActiveFilterCount() {
    int count = 0;

    if (_appliedFilters['dateRange'] != null) count++;
    if (_appliedFilters['distance'] != null &&
        _appliedFilters['distance'] != 50.0)
      count++;
    if (_appliedFilters['campTypes'] != null &&
        (_appliedFilters['campTypes'] as List).isNotEmpty) {
      count += (_appliedFilters['campTypes'] as List).length;
    }
    if (_appliedFilters['availableOnly'] == true) count++;

    return count;
  }

  Future<void> _refreshCamps() async {
    await _loadCamps();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Camps updated'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _navigateToCampDetails(Map<String, dynamic> camp) {
    Navigator.pushNamed(context, '/camp-details-screen', arguments: camp);
  }

  Future<void> _toggleFavorite(Map<String, dynamic> camp) async {
    await _campService.toggleFavorite(camp['id'] as int);
    _loadCamps(); // Reload to get updated data

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          camp['isFavorite'] == true
              ? 'Removed from favorites'
              : 'Added to favorites',
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: const Duration(seconds: 2),
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
