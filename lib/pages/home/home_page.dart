import 'package:ai_translate/main.dart';
import 'package:ai_translate/pages/home/home_controller.dart';
import 'package:ai_translate/routes/pages.dart';
import 'package:ai_translate/theme/style/style_theme.dart';
import 'package:ai_translate/utils/app_constants.dart';
import 'package:ai_translate/utils/icons_assets.dart';
import 'package:ai_translate/widget/default_app_bar.dart';
import 'package:ai_translate/widget/reponsive/extension.dart';
import 'package:ai_translate/widget/select_tab_widget.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: AppConstants.appName, backButton: false),
      body: Obx(
        () => Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              controller.isHeadphoneConnected.value
                  ? Column(
                      children: [
                        Icon(Icons.headset, size: 100.w, color: appTheme.succussColor),
                      ],
                    )
                  : Column(
                      children: [
                        Icon(Icons.headset_off, size: 100.w, color: appTheme.redColor),
                        SizedBox(height: 10.h),
                        Text(
                          "Chưa kết nối tai nghe!",
                          style: StyleThemeData.size18Weight700(color: appTheme.redColor),
                        ),
                      ],
                    ),
              SizedBox(height: 24.h),
              if (!controller.isHeadphoneConnected.value) ...[
                ElevatedButton(
                  onPressed: () {
                    AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
                  },
                  child: Text(controller.isHeadphoneConnected.value ? "Ngắt kết nối" : "Kết nối tai nghe"),
                ),
              ] else ...[
                SelectTabWidget(
                  icon: IconsAssets.chatsIcon,
                  title: 'Chế độ đối thoại AI',
                  onTap: () => Get.toNamed(Routes.CHATS),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
