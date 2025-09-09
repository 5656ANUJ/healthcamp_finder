import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import '../find_camps_screen/find_camps_screen.dart';
import '../list_camp_screen/list_camp_screen.dart';
import '../map_screen/map_screen.dart';
import '../profile_screen/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 1; // Start with Find Camp as default

  final List<Widget> _screens = [
    const ListCampScreen(),
    const FindCampsScreen(),
    const ProfileScreen(),
    const MapScreen(),
  ];

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: 'add_circle',
      activeIcon: 'add_circle',
      label: 'List Camp',
    ),
    NavigationItem(icon: 'search', activeIcon: 'search', label: 'Find Camp'),
    NavigationItem(icon: 'person', activeIcon: 'person', label: 'Profile'),
    NavigationItem(icon: 'map', activeIcon: 'map', label: 'Map'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow.withValues(
                alpha: 0.1,
              ),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 8.h,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  _navigationItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isSelected = _selectedIndex == index;

                    return GestureDetector(
                      onTap: () => _onItemTapped(index),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.all(isSelected ? 1.w : 0.5.w),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? AppTheme
                                            .lightTheme
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: 0.1)
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CustomIconWidget(
                                iconName:
                                    isSelected ? item.activeIcon : item.icon,
                                color:
                                    isSelected
                                        ? AppTheme
                                            .lightTheme
                                            .colorScheme
                                            .primary
                                        : AppTheme
                                            .lightTheme
                                            .colorScheme
                                            .onSurfaceVariant,
                                size: 6.w,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: AppTheme.lightTheme.textTheme.bodySmall!
                                  .copyWith(
                                    color:
                                        isSelected
                                            ? AppTheme
                                                .lightTheme
                                                .colorScheme
                                                .primary
                                            : AppTheme
                                                .lightTheme
                                                .colorScheme
                                                .onSurfaceVariant,
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                    fontSize: 10.sp,
                                  ),
                              child: Text(
                                item.label,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      // Add haptic feedback for better UX
      // HapticFeedback.selectionClick();
    }
  }
}

class NavigationItem {
  final String icon;
  final String activeIcon;
  final String label;

  const NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
