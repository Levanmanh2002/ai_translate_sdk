import 'package:ai_translate/main.dart';
import 'package:ai_translate/pages/chats/chats_controller.dart';
import 'package:ai_translate/theme/style/style_theme.dart';
import 'package:ai_translate/utils/app/app_enum.dart';
import 'package:ai_translate/utils/images_assets.dart';
import 'package:ai_translate/widget/image_asset_custom.dart';
import 'package:ai_translate/widget/reponsive/extension.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSendMessView extends GetView<ChatsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: padding(top: 12, horizontal: 12, bottom: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: null, icon: SizedBox()),
            IconButton(
              onPressed: controller.isListening.isFalse
                  ? () => controller.startListening(isStartTime: true)
                  : controller.stopListening,
              icon: controller.isListening.isTrue
                  ? ImageAssetCustom(imagePath: ImagesAssets.voiceImage, size: 100.w)
                  : ImageAssetCustom(imagePath: ImagesAssets.voiceOpacityImage, size: 68.w),
            ),
            Obx(() {
              final fromLangItems =
                  Languages.values.where((lang) => lang != controller.selectedLanguage.value).toList();

              if (!fromLangItems.contains(controller.fromLang.value)) {
                controller.fromLang.value = fromLangItems.first;
              }

              return SizedBox(
                height: 40.h,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<Languages>(
                    value: controller.fromLang.value,
                    items: fromLangItems.map((lang) {
                      return DropdownMenuItem<Languages>(
                        value: lang,
                        child: Text(
                          controller.languageLabels[lang] ?? '',
                          style: StyleThemeData.size14Weight400(),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.toggleFromLanguage(value);
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
              );
            }),
          ],
        ),
      ),
    );
  }
}
