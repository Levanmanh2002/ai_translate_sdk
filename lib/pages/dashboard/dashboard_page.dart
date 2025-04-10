// ignore_for_file: use_key_in_widget_constructors

import 'package:ai_translate/main.dart';
import 'package:ai_translate/pages/dashboard/dashboard_controller.dart';
import 'package:ai_translate/theme/style/style_theme.dart';
import 'package:ai_translate/utils/icons_assets.dart';
import 'package:ai_translate/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class DashboardPage extends GetWidget<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: controller.pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: controller.animateToTab,
              children: [...controller.pages],
            ),
          ),
          Container(
            padding: padding(left: 12, right: 12, top: 12, bottom: 12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: appTheme.sliverColor, width: 1.w),
              ),
              color: appTheme.whiteColor,
            ),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _bottomAppBarItem(
                    context,
                    icon: IconsAssets.homeIcon,
                    page: 0,
                    label: 'Trang chủ'.tr,
                  ),
                  _bottomAppBarItem(
                    context,
                    icon: IconsAssets.userIcon,
                    page: 1,
                    label: 'Hồ sơ'.tr,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomAppBarItem(
    BuildContext context, {
    required String icon,
    required int page,
    required String label,
    Widget? avatar,
    Widget? widget,
  }) {
    return ZoomTapAnimation(
      onTap: () => controller.goToTab(page),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              avatar == null
                  ? SvgPicture.asset(
                      icon,
                      width: 24.w,
                      color: controller.currentPage.value == page ? appTheme.appColor : appTheme.grayColor,
                    )
                  : const SizedBox(),
              widget ?? Container(),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: StyleThemeData.size10Weight400(
              color: controller.currentPage.value == page ? appTheme.appColor : appTheme.grayColor,
            ),
          ),
        ],
      ),
    );
  }
}
