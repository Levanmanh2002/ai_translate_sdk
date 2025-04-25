import 'package:ai_translate/main.dart';
import 'package:ai_translate/theme/style/style_theme.dart';
import 'package:ai_translate/widget/image_asset_custom.dart';
import 'package:ai_translate/widget/primary_button.dart';
import 'package:ai_translate/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class DialogUtils {
  static showDialogView(Widget view) {
    return showDialog(
      context: Get.context!,
      useRootNavigator: false,
      builder: (context) => Dialog(
        backgroundColor: appTheme.whiteColor,
        child: view,
      ),
    );
  }

  static showBTSView(Widget view, {bool isWrap = false}) {
    return showModalBottomSheet(
      context: Get.context!,
      constraints: !isWrap ? BoxConstraints(maxWidth: double.infinity, maxHeight: Get.height * .75) : null,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      builder: (context) {
        final isKeyboardShow = MediaQuery.of(Get.context!).viewInsets.bottom > 0;
        if (isWrap) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).viewInsets.bottom),
            child: Wrap(
              children: [view],
            ),
          );
        }
        return Container(
          height: !isWrap ? Get.height * (.75 + (isKeyboardShow ? .15 : 0)) : null,
          constraints: !isWrap
              ? BoxConstraints(maxWidth: double.infinity, maxHeight: Get.height * (.75 + (isKeyboardShow ? .15 : 0)))
              : null,
          padding: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).viewInsets.bottom),
          child: Padding(padding: padding(all: 12), child: view),
        );
      },
    );
  }

  static Future<T?> showYesNoDialog<T>({
    Function()? onNegative,
    Function()? onPositive,
    String? labelNegative,
    String? labelPositive,
    Color? labelPostiveColor,
    required String title,
    String? description,
  }) async {
    return await showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (context) {
        return Padding(
          padding: padding(horizontal: 12),
          child: Dialog(
            surfaceTintColor: appTheme.whiteColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            insetPadding: EdgeInsets.zero,
            child: Padding(
              padding: padding(vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: padding(horizontal: 16),
                    child: Text(title, textAlign: TextAlign.center, style: StyleThemeData.size24Weight700()),
                  ),
                  if (description != null) ...[
                    SizedBox(height: 8.h),
                    Text(description, style: StyleThemeData.size16Weight400()),
                  ],
                  SizedBox(height: 20.h),
                  Padding(
                    padding: padding(horizontal: 16),
                    child: Column(
                      children: [
                        SizedBox(
                          width: Get.size.width.w,
                          child: PrimaryButton(
                            backgroundColor: appTheme.appColor,
                            borderColor: appTheme.whiteColor,
                            contentPadding: padding(vertical: 12),
                            onPressed: onPositive ?? () => Get.back(result: true),
                            radius: BorderRadius.circular(12),
                            child: Text(
                              labelPositive ?? "yes".tr,
                              style: StyleThemeData.size16Weight400(color: labelPostiveColor ?? appTheme.whiteColor),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        SizedBox(
                          width: Get.size.width.w,
                          child: PrimaryButton(
                            backgroundColor: appTheme.whiteColor,
                            borderColor: appTheme.appColor,
                            contentPadding: padding(vertical: 11),
                            onPressed: onNegative ?? () => Get.back(result: false),
                            radius: BorderRadius.circular(12),
                            child: Text(
                              labelNegative ?? "no".tr,
                              style: StyleThemeData.size16Weight400(color: appTheme.appColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static showSuccessDialog(
    String content,
  ) {
    toastification.show(
      context: Get.context!,
      title: Text(content, maxLines: 3, overflow: TextOverflow.ellipsis),
      autoCloseDuration: const Duration(seconds: 3),
      showProgressBar: false,
      type: ToastificationType.success,
      icon: Container(
        padding: padding(all: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: appTheme.green50Color,
        ),
        child: Icon(Icons.check, size: 16.w, color: appTheme.whiteColor),
      ),
    );
  }

  static showErrorDialog(String content) {
    toastification.show(
      context: Get.context!,
      title: Text(content, maxLines: 3, overflow: TextOverflow.ellipsis),
      autoCloseDuration: const Duration(seconds: 3),
      showProgressBar: false,
      type: ToastificationType.error,
      icon: Icon(Icons.error, size: 24.w, color: appTheme.redColor),
    );
  }

  static showWarningDialog(String content) {
    toastification.show(
      context: Get.context!,
      title: Text(content, maxLines: 3, overflow: TextOverflow.ellipsis),
      autoCloseDuration: const Duration(seconds: 3),
      showProgressBar: false,
      type: ToastificationType.warning,
      // icon: Icon(Icons.error, size: 24.w, color: appTheme.redColor),
    );
  }

  static showInfoErrorDialog({
    String content = '',
    String? title,
    TextStyle? contentStyle,
    EdgeInsets? contentPadding,
    String? primaryText,
    String? outlineText,
    bool? barrierDismissible,
  }) async {
    return showDialog(
      context: Get.context!,
      barrierDismissible: barrierDismissible ?? false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: PopScope(
            canPop: false,
            child: Container(
              width: 305.w,
              decoration: BoxDecoration(
                color: appTheme.whiteColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Padding(
                    padding: padding(top: 16, right: 19),
                    child: GestureDetector(onTap: Get.back, child: const Icon(Icons.close, size: 24)),
                  ),
                  SizedBox(
                    width: 305.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 32.h),
                        Padding(
                          padding: padding(horizontal: 12),
                          child: Text(
                            title ?? "apologize".tr,
                            style: StyleThemeData.size24Weight700(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: contentPadding ?? padding(horizontal: 24),
                          child: Text(
                            content,
                            textAlign: TextAlign.center,
                            style: contentStyle ?? StyleThemeData.size16Weight400(),
                          ),
                        ),
                        SizedBox(height: 36.h)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Future showWaitingDialog({
    String imageWaiting = '',
    String description = '',
    double? imageSize,
  }) async {
    return await showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          surfaceTintColor: appTheme.whiteColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: padding(all: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageAssetCustom(imagePath: imageWaiting, size: imageSize ?? 300.w),
                SizedBox(height: 16.h),
                Text(description, style: StyleThemeData.size16Weight700(), textAlign: TextAlign.center),
              ],
            ),
          ),
        );
      },
    );
  }
}
