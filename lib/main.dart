import 'package:ai_translate/ai_translate_sdk_main.dart';
import 'package:ai_translate/theme/app_theme_util.dart';
import 'package:ai_translate/theme/base_theme_data.dart';
import 'package:flutter/material.dart';

AppThemeUtil themeUtil = AppThemeUtil();
BaseThemeData get appTheme => themeUtil.getAppTheme();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dashboardPage = await initAiTranslateSdk();

  runApp(
    MaterialApp(home: dashboardPage),
  );
}
