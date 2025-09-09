import 'package:flutter/material.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/camp_details_screen/camp_details_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/find_camps_screen/find_camps_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/list_camp_screen/list_camp_screen.dart';
import '../presentation/main_navigation_screen/main_navigation_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String login = '/login-screen';
  static const String mainNavigation = '/main-navigation';
  static const String campDetails = '/camp-details-screen';
  static const String profile = '/profile-screen';
  static const String findCamps = '/find-camps-screen';
  static const String home = '/home-screen';
  static const String listCamp = '/list-camp-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const MainNavigationScreen(),
    login: (context) => const LoginScreen(),
    mainNavigation: (context) => const MainNavigationScreen(),
    campDetails: (context) => const CampDetailsScreen(),
    profile: (context) => const ProfileScreen(),
    findCamps: (context) => const FindCampsScreen(),
    home: (context) => const HomeScreen(),
    listCamp: (context) => const ListCampScreen(),
    // TODO: Add your other routes here
  };
}
