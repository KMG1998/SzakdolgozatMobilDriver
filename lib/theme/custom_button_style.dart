import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:szakdolgozat_mobil_driver_side/core/app_export.dart';
import 'package:flutter/material.dart';

/// A class that offers pre-defined button styles for customizing button appearance.
class CustomButtonStyles {
  // Outline button style
  static ButtonStyle get outlineBlack => OutlinedButton.styleFrom(
        backgroundColor: theme.colorScheme.onSecondaryContainer,
        side: BorderSide(
          color: appTheme.black900,
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.h),
        ),
      );
  static ButtonStyle get outlineRed=> OutlinedButton.styleFrom(
    backgroundColor: theme.colorScheme.onSecondaryContainer,
    side: BorderSide(
      color: Colors.redAccent,
      width: 2,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14.h),
    ),
  );

  static ButtonStyle get outlineGreen=> OutlinedButton.styleFrom(
    backgroundColor: theme.colorScheme.onSecondaryContainer,
    side: BorderSide(
      color: Colors.green,
      width: 2,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14.h),
    ),
  );

  // text button style
  static ButtonStyle get none => ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
        elevation: WidgetStateProperty.all<double>(0),
      );
}
