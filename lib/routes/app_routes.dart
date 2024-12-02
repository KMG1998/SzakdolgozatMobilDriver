import 'package:flutter/material.dart';
import 'package:szakdolgozat_mobil_driver_side/pages/auth/login_screen.dart';
import 'package:szakdolgozat_mobil_driver_side/pages/driver/driver_dashboard_screen.dart';
import 'package:szakdolgozat_mobil_driver_side/pages/auth/driver_registration_screen.dart';
import 'package:szakdolgozat_mobil_driver_side/pages/history/driver_history_page.dart';
import 'package:szakdolgozat_mobil_driver_side/pages/history/history_order_details_page.dart';
import 'package:szakdolgozat_mobil_driver_side/pages/profile/driver_profile_page.dart';
import 'package:szakdolgozat_mobil_driver_side/pages/profile/received_review_list.dart';
import 'package:szakdolgozat_mobil_driver_side/pages/profile/vehicle_data_page.dart';
import 'package:szakdolgozat_mobil_driver_side/pages/splash/splash_screen.dart';

class AppRoutes {
  static const String driverRegistrationScreen = '/driver_registration_screen';
  static const String loginScreen = '/login_screen';
  static const String driverDashboardScreen = '/driver_dashboard_screen';
  static const String driverHistoryPage = '/driver_history_page';
  static const String driverProfilePage = '/driver_profile_page';
  static const String historyOrderDetailsPage = '/history_order_details_page';
  static const String splashScreen = '/splash_screen';
  static const String receivedReviews = '/received_reviews';
  static const String vehicleDataPage = '/vehicle_data_page';

  static Map<String, WidgetBuilder> routes = {
    driverRegistrationScreen: (context) => const DriverRegistrationScreen(),
    loginScreen: (context) => const LoginScreen(),
    driverDashboardScreen: (context) => DriverDashboardScreen(),
    driverHistoryPage: (context) => DriverHistoryPage(),
    driverProfilePage: (context) => DriverProfilePage(),
    historyOrderDetailsPage: (context) => HistoryOrderDetails(),
    splashScreen: (context) => SplashScreen(),
    receivedReviews: (context) => ReceivedReviewList(),
    vehicleDataPage: (context) => VehicleDataPage(),
  };
}
