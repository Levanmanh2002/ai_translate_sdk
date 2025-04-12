import 'package:ai_translate/pages/chats/chats_binding.dart';
import 'package:ai_translate/pages/chats/chats_page.dart';
import 'package:ai_translate/pages/dashboard/dashboard_binding.dart';
import 'package:ai_translate/pages/dashboard/dashboard_page.dart';
import 'package:ai_translate/pages/splash/splash_binding.dart';
import 'package:ai_translate/pages/splash/splash_page.dart';
import 'package:get/get.dart';

part 'routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.CHATS,
      page: () => ChatsPage(),
      binding: ChatsBinding(),
    ),
  ];
}
