import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

String _appTheme = "primary";

class ThemeHelper {
  final Map<String, PrimaryColors> _supportedCustomColor = {
    'primary': PrimaryColors()
  };

  final Map<String, ColorScheme> _supportedColorScheme = {
    'primary': ColorSchemes.primaryColorScheme
  };

  void changeTheme(String newTheme) {
    _appTheme = newTheme;
  }

  PrimaryColors _getThemeColors() {
    if (!_supportedCustomColor.containsKey(_appTheme)) {
      throw Exception(
          "$_appTheme is not found.Make sure you have added this theme class in JSON Try running flutter pub run build_runner");
    }

    return _supportedCustomColor[_appTheme] ?? PrimaryColors();
  }

  ThemeData _getThemeData() {
    if (!_supportedColorScheme.containsKey(_appTheme)) {
      throw Exception(
          "$_appTheme is not found.Make sure you have added this theme class in JSON Try running flutter pub run build_runner");
    }

    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.primaryColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: BorderSide(
            color: appTheme.black,
            width: 2.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.h),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: appTheme.black,
      ),
    );
  }

  PrimaryColors themeColor() => _getThemeColors();

  ThemeData themeData() => _getThemeData();
}

class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
    bodyMedium: TextStyle(
      color: appTheme.black,
      fontSize: 14.sp,
      fontFamily: 'JetBrains Mono',
      fontWeight: FontWeight.w400,
    ),
    bodyLarge: TextStyle(
      color: appTheme.black,
      fontSize: 24.sp,
      fontFamily: 'JetBrains Mono',
      fontWeight: FontWeight.w400,
    ),
    headlineLarge: TextStyle(
      color: appTheme.black,
      fontSize: 30.sp,
      fontFamily: 'JetBrains Mono',
      fontWeight: FontWeight.w400,
    ),
    titleLarge: TextStyle(
      color: appTheme.black,
      fontSize: 20.sp,
      fontFamily: 'JetBrains Mono',
      fontWeight: FontWeight.w400,
    ),
  );
}

class ColorSchemes {
  static final primaryColorScheme = ColorScheme.light(
    // Primary colors
    primary: Color(0XCCFFFFFF),
    primaryContainer: Color(0XFF57A3EF),

    // On colors(text colors)
    onPrimary: Color(0XFFAD0C0C),
    onSecondaryContainer: Color(0XFFFFFFFF),
  );
}

class PrimaryColors {
  // Black
  Color get black => Color(0XFF000000);

  // Blue
  Color get blue100 => Color(0XFFC9E1F9);
  Color get blue10001 => Color(0XFFB2D8FF);
}

PrimaryColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();
