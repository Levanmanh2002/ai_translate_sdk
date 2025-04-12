import 'package:ai_translate/pages/chats/chats_controller.dart';
import 'package:ai_translate/utils/images_assets.dart';
import 'package:ai_translate/widget/image_asset_custom.dart';
import 'package:ai_translate/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSendMessView extends GetView<ChatsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: padding(top: 12, horizontal: 12, bottom: 24),
        child: IconButton(
          onPressed: controller.isListening.isFalse ? controller.startListening : controller.stopListening,
          icon: controller.isListening.isTrue
              ? ImageAssetCustom(imagePath: ImagesAssets.voiceImage, size: 100.w)
              : ImageAssetCustom(imagePath: ImagesAssets.voiceOpacityImage, size: 68.w),
        ),
      ),
    );
  }
}
