import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:szakdolgozat_mobil_driver_side/pages/splash/splash_screen.dart';
import 'package:szakdolgozat_mobil_driver_side/qubit/auth/auth_cubit.dart';
import 'package:szakdolgozat_mobil_driver_side/qubit/history/history_cubit.dart';
import 'package:szakdolgozat_mobil_driver_side/qubit/order/order_cubit.dart';
import 'package:szakdolgozat_mobil_driver_side/qubit/reviewList/review_list_cubit.dart';
import 'package:szakdolgozat_mobil_driver_side/qubit/user/user_cubit.dart';
import 'package:szakdolgozat_mobil_driver_side/routes/app_routes.dart';
import 'package:szakdolgozat_mobil_driver_side/theme/theme_helper.dart';

import 'core/utils/service_locator.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  ThemeHelper().changeTheme('primary');
  initServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(675,948),
      builder: (_ , child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => AuthCubit()),
            BlocProvider(create: (context) => OrderCubit()),
            BlocProvider(create: (context) => UserCubit()),
            BlocProvider(create: (context) => HistoryCubit()),
            BlocProvider(create: (context) => ReviewListCubit()),
          ],
          child: MaterialApp(
            theme: theme,
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
            routes: AppRoutes.routes,
            navigatorKey: navigatorKey,
          ),
        );
      },
    );
  }
}
