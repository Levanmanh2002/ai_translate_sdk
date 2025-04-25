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

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await LocalStorage.init();
//   await AppService.initAppService();

//   await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

//   runApp(LayoutBuilder(builder: (context, constraints) {
//     SizeConfig.instance.init(constraints: constraints, screenHeight: 812, screenWidth: 375);

//     return const AiTranslateSdkMain();
//   }));
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   void dispose() {
//     themeUtil.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MediaQuery(
//       data: MediaQuery.of(context).copyWith(
//         textScaler: const TextScaler.linear(1.0),
//       ),
//       child: GetMaterialApp(
//         title: AppConstants.appName,
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           scaffoldBackgroundColor: appTheme.whiteColor,
//           dialogBackgroundColor: appTheme.whiteColor,
//           appBarTheme: AppBarTheme.of(context).copyWith(
//             backgroundColor: appTheme.whiteColor,
//             surfaceTintColor: appTheme.whiteColor,
//           ),
//           primarySwatch: MaterialColor(
//             appTheme.appColor.value,
//             <int, Color>{
//               50: appTheme.appColor,
//               100: appTheme.appColor,
//               200: appTheme.appColor,
//               300: appTheme.appColor,
//               400: appTheme.appColor,
//               500: appTheme.appColor,
//               600: appTheme.appColor,
//               700: appTheme.appColor,
//               800: appTheme.appColor,
//               900: appTheme.appColor,
//             },
//           ),
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//           splashColor: appTheme.transparentColor,
//           highlightColor: appTheme.transparentColor,
//         ),
//         initialRoute: Routes.SPLASH,
//         getPages: AppPages.pages,
//         builder: EasyLoading.init(),
//       ),
//     );
//   }
// }
