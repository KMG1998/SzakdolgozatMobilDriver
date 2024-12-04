import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:szakdolgozat_mobil_driver_side/theme/app_decoration.dart';
import 'package:szakdolgozat_mobil_driver_side/theme/theme_helper.dart';
import 'package:szakdolgozat_mobil_driver_side/widgets/custom_outlined_button.dart';

class BackgroundLocationPermissionDialog extends StatelessWidget {
  const BackgroundLocationPermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 550.w,
        height: 250.h,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadiusStyle.circleBorder15,
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'GPS engedély',
              style: theme.textTheme.headlineLarge,
            ),
            SizedBox(height: 20),
            Text(
              'Kérjük, az alkalmazás megfelelő működése érdekében engedélyezze a folyamatos GPS hozzáférést!',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            Expanded(child: SizedBox()),
            CustomOutlinedButton(
              text: 'Rendben',
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      ),
    );
  }
}
