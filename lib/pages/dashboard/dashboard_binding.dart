import 'package:ai_translate/pages/dashboard/dashboard_controller.dart';
import 'package:ai_translate/pages/home/home_controller.dart';
import 'package:ai_translate/pages/profile/profile_controller.dart';
import 'package:get/get.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController(authRepository: Get.find()));
    Get.put(HomeController());
    Get.put(ProfileController());
  }
}
