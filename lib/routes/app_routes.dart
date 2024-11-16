import 'package:flutter/material.dart';
import 'package:szakdolgozat_mobil_driver_side/pages/auth/login_screen.dart';
import 'package:szakdolgozat_mobil_driver_side/pages/driver/driver_dashboard_screen.dart';
import 'package:szakdolgozat_mobil_driver_side/pages/auth/driver_registration_screen.dart';

class AppRoutes {
  static const String driverRegistrationScreen =
      '/driver_registration_screen';

  static const String passengerDashboardPage = '/passenger_dashboard_page';

  static const String loginScreen = '/login_screen';

  static const String driverDashboardScreen = '/driver_dashboard_screen';

  static const String newReserveCarSelectScreen =
      '/new_reserve_car_select_screen';

  static const String newReserveWaitScreen = '/new_reserve_wait_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static Map<String, WidgetBuilder> routes = {
    driverRegistrationScreen: (context) => const DriverRegistrationScreen(),
    loginScreen: (context) => const LoginScreen(),
    driverDashboardScreen: (context) => DriverDashboardScreen(),
  };
}
