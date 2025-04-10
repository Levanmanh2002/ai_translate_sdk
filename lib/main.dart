import 'package:ai_translate/resourese/service/app_service.dart';
import 'package:ai_translate/routes/pages.dart';
import 'package:ai_translate/theme/app_theme_util.dart';
import 'package:ai_translate/theme/base_theme_data.dart';
import 'package:ai_translate/utils/app_constants.dart';
import 'package:ai_translate/utils/local_storage.dart';
import 'package:ai_translate/widget/reponsive/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

AppThemeUtil themeUtil = AppThemeUtil();
BaseThemeData get appTheme => themeUtil.getAppTheme();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  await AppService.initAppService();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(LayoutBuilder(builder: (context, constraints) {
    SizeConfig.instance.init(constraints: constraints, screenHeight: 812, screenWidth: 375);

    return const MyApp();
  }));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    themeUtil.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: GetMaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: appTheme.whiteColor,
          dialogBackgroundColor: appTheme.whiteColor,
          appBarTheme: AppBarTheme.of(context).copyWith(
            backgroundColor: appTheme.whiteColor,
            surfaceTintColor: appTheme.whiteColor,
          ),
          primarySwatch: MaterialColor(
            appTheme.appColor.value,
            <int, Color>{
              50: appTheme.appColor,
              100: appTheme.appColor,
              200: appTheme.appColor,
              300: appTheme.appColor,
              400: appTheme.appColor,
              500: appTheme.appColor,
              600: appTheme.appColor,
              700: appTheme.appColor,
              800: appTheme.appColor,
              900: appTheme.appColor,
            },
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          splashColor: appTheme.transparentColor,
          highlightColor: appTheme.transparentColor,
        ),
        initialRoute: Routes.SPLASH,
        getPages: AppPages.pages,
        builder: EasyLoading.init(),
      ),
    );
  }
}
