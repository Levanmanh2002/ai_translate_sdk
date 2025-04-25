import 'package:ai_translate/pages/home/home_binding.dart';
import 'package:ai_translate/pages/home/home_page.dart';
import 'package:ai_translate/resourese/service/app_service.dart';
import 'package:ai_translate/utils/local_storage.dart';
import 'package:ai_translate/widget/reponsive/size_config.dart';
import 'package:flutter/material.dart';

Future<Widget> initAiTranslateSdk({BoxConstraints? constraints}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  await AppService.initAppService();

  if (constraints != null) {
    SizeConfig.instance.init(constraints: constraints, screenHeight: 812, screenWidth: 375);
  } else {
    SizeConfig.instance.init(
      constraints: BoxConstraints(maxWidth: 375, maxHeight: 812),
      screenHeight: 812,
      screenWidth: 375,
    );
  }

  HomeBinding().dependencies();

  return HomePage();
}
