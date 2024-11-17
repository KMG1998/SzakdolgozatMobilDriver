import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:szakdolgozat_mobil_driver_side/pages/auth/login_screen.dart';
import 'package:szakdolgozat_mobil_driver_side/qubit/login/login_cubit.dart';
import 'package:szakdolgozat_mobil_driver_side/qubit/order/order_cubit.dart';
import 'package:szakdolgozat_mobil_driver_side/qubit/user/user_cubit.dart';
import 'package:szakdolgozat_mobil_driver_side/routes/app_routes.dart';
import 'package:szakdolgozat_mobil_driver_side/theme/theme_helper.dart';

import 'core/utils/service_locator.dart';
import 'core/utils/size_utils.dart';

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
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => LoginCubit()),
            BlocProvider(create: (context) => OrderCubit()),
            BlocProvider(create: (context) => UserCubit()),
          ],
          child: MaterialApp(
            theme: theme,
            debugShowCheckedModeBanner: false,
            home: const LoginScreen(),
            routes: AppRoutes.routes,
            navigatorKey: navigatorKey,
          ),
        );
      },
    );
  }
}
