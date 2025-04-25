import 'package:ai_translate/pages/home/home_page.dart';
import 'package:ai_translate/pages/profile/profile_page.dart';
import 'package:ai_translate/resourese/auth/iauth_repository.dart';
import 'package:ai_translate/utils/local_storage.dart';
import 'package:ai_translate/utils/shared_key.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final IAuthRepository authRepository;

  DashboardController({required this.authRepository});

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
    login();
    super.onInit();
  }

  void login() async {
    try {
      Map<String, String> params = {
        "email": "hvmq1333@gmail.com",
        "password": "@Qq123456",
        "device": "1234",
      };

      final response = await authRepository.login(params);

      if (response.statusCode == 200) {
        await LocalStorage.remove(SharedKey.token);
        await LocalStorage.setString(SharedKey.token, response.body['token']);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
