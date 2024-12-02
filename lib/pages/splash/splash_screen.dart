import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:szakdolgozat_mobil_driver_side/core/utils/service_locator.dart';
import 'package:szakdolgozat_mobil_driver_side/generated/assets.gen.dart';
import 'package:szakdolgozat_mobil_driver_side/main.dart';
import 'package:szakdolgozat_mobil_driver_side/routes/app_routes.dart';
import 'package:szakdolgozat_mobil_driver_side/services/user_service.dart';
import 'package:szakdolgozat_mobil_driver_side/theme/theme_helper.dart';
import 'package:szakdolgozat_mobil_driver_side/widgets/custom_image_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checkToken() async {
    final tokenValid = await getIt.get<UserService>().checkToken();
    if (tokenValid) {
      navigatorKey.currentState!.pushReplacementNamed(AppRoutes.driverDashboardScreen);
      return;
    }
    await getIt.get<FlutterSecureStorage>().delete(key: 'token');
    navigatorKey.currentState!.pushReplacementNamed(AppRoutes.loginScreen);
  }

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
          child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: const Alignment(0.5, 0),
              end: const Alignment(0.5, 1),
              colors: [
                theme.colorScheme.primaryContainer,
                appTheme.blue100,
                theme.colorScheme.onSecondaryContainer,
              ],
            ),
          ),
          child: Center(
            child: Column(
              children: [
                CustomImageView(
                  imagePath: Assets.lib.assets.images.magantaxiLogo.path,
                  height: 319.h,
                  width: 319.w,
                ),
                LoadingIndicator(
                  indicatorType: Indicator.ballClipRotatePulse,
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
