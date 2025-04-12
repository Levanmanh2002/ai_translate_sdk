import 'dart:developer';

import 'package:get/get.dart';
import 'package:headset_connection_event/headset_event.dart';

class HomeController extends GetxController {
  var isHeadphoneConnected = false.obs;
  var headphoneName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initHeadsetEvent();
  }

  void initHeadsetEvent() {
    HeadsetEvent headsetPlugin = HeadsetEvent();

    headsetPlugin.getCurrentState.then((val) {
      if (val == HeadsetState.CONNECT) {
        isHeadphoneConnected.value = true;
      } else if (val == HeadsetState.DISCONNECT) {
        isHeadphoneConnected.value = false;
      }
      log("🔊 Bluetooth đã được kết nối headset_connection_event: ${val.toString()}");
    });

    headsetPlugin.setListener((val) {
      if (val == HeadsetState.CONNECT) {
        isHeadphoneConnected.value = true;
      } else if (val == HeadsetState.DISCONNECT) {
        isHeadphoneConnected.value = false;
      }
      log("🔊 Bluetooth đã được kết nối4: ${val.toString()}");
    });
  }
}
