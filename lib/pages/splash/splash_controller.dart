import 'package:ai_translate/routes/pages.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 500)).then((value) => init());
  }

  void init() async {
    Get.offAllNamed(Routes.DASHBOARD);
  }
}
