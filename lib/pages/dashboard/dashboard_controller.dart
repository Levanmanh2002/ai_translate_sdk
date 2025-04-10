import 'package:ai_translate/pages/home/home_page.dart';
import 'package:ai_translate/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  late PageController pageController;

  RxInt currentPage = 0.obs;

  List<Widget> pages = [
    HomePage(),
    ProfilePage(),
  ];

  void switchTheme(ThemeMode mode) {
    Get.changeThemeMode(mode);
  }

  void goToTab(int page) {
    currentPage.value = page;
    pageController.jumpToPage(page);
  }

  void animateToTab(int page) {
    currentPage.value = page;
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);

    super.onInit();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
