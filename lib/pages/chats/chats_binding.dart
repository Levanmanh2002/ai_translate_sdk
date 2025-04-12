import 'package:ai_translate/pages/chats/chats_controller.dart';
import 'package:get/get.dart';

class ChatsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ChatsController(
        translateRepository: Get.find(),
      ),
    );
  }
}
