import 'package:ai_translate/theme/base_theme_data.dart';
import 'package:ai_translate/theme/style/base_app_theme.dart';
import 'package:flutter/material.dart';

class AppThemeDefault extends BaseAppTheme<AppLightThemeDefault, AppDartThemeDefault> {
  @override
  AppDartThemeDefault get darkTheme => AppDartThemeDefault();

  @override
  AppLightThemeDefault get lightTheme => AppLightThemeDefault();
}

class AppLightThemeDefault extends BaseThemeData {
  @override
  Color get primaryColor => const Color(0xFF0F172A);
}

class AppDartThemeDefault extends BaseThemeData {
  @override
  Color get primaryColor => Colors.white;
}
