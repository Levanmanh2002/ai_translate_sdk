import 'package:ai_translate/main.dart';
import 'package:ai_translate/pages/chats/chats_controller.dart';
import 'package:ai_translate/pages/chats/view/bottom_send_mess_view.dart';
import 'package:ai_translate/pages/chats/view/chat_list_view.dart';
import 'package:ai_translate/pages/home/home_controller.dart';
import 'package:ai_translate/theme/style/style_theme.dart';
import 'package:ai_translate/utils/app/app_enum.dart';
import 'package:ai_translate/utils/icons_assets.dart';
import 'package:ai_translate/widget/default_app_bar.dart';
import 'package:ai_translate/widget/image_asset_custom.dart';
import 'package:ai_translate/widget/reponsive/extension.dart';
import 'package:app_settings/app_settings.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsPage extends GetWidget<ChatsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.blueFFColor,
      appBar: DefaultAppBar(
        title: 'Đối thoại AI',
        actions: [
          Obx(
            () => SizedBox(
              height: 40.h,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<Languages>(
                  value: controller.selectedLanguage.value,
                  items: Languages.values.map((lang) {
                    return DropdownMenuItem<Languages>(
                      value: lang,
                      child: Text(
                        controller.languageLabels[lang]!,
                        style: StyleThemeData.size14Weight400(),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.toggleLanguage(value);
                    }
                  },
                  iconStyleData: const IconStyleData(icon: SizedBox.shrink()),
                  buttonStyleData: ButtonStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1000),
                      border: Border.all(width: 1, color: appTheme.appColor),
                      color: appTheme.whiteColor,
                    ),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: appTheme.whiteColor),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
        ],
      ),
      body: Obx(
        () => Get.find<HomeController>().isHeadphoneConnected.value
            ? Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ChatListView(),
                        Obx(
                          () => controller.isShowScrollToBottom.value
                              ? Positioned(bottom: 12, right: 16, child: _buildScrollToBottomMess())
                              : const SizedBox(),
                        ),
                        Obx(
                          () => controller.isLoading.isTrue
                              ? Center(child: CircularProgressIndicator(color: appTheme.appColor))
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                  Center(child: BottomSendMessView()),
                ],
              )
            : Center(
                child: ElevatedButton(
                  onPressed: () {
                    AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
                  },
                  child: Text('Kết nối tai nghe'),
                ),
              ),
      ),
    );
  }

  Widget _buildScrollToBottomMess() {
    return InkWell(
      onTap: controller.scrollToBottom,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: padding(all: 8),
        decoration: BoxDecoration(shape: BoxShape.circle, color: appTheme.whiteColor),
        child: const ImageAssetCustom(imagePath: IconsAssets.doubleArrowDownIcon),
      ),
    );
  }
}
