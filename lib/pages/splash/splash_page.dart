// ignore_for_file: use_key_in_widget_constructors

import 'package:ai_translate/main.dart';
import 'package:ai_translate/pages/splash/splash_controller.dart';
import 'package:ai_translate/utils/images_assets.dart';
import 'package:ai_translate/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends GetWidget<SplashController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.appColor,
      body: Center(
        child: Padding(
          padding: padding(all: 24),
          child: Image.asset(ImagesAssets.noImage, width: 214.w),
        ),
      ),
    );
  }
}
