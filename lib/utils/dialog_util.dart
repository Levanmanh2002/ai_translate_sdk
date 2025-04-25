import 'package:ai_translate/main.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class DialogUtils {
  static showSuccessDialog(String content, BuildContext context) {
    toastification.show(
      context: context,
      title: Text(content, maxLines: 3, overflow: TextOverflow.ellipsis),
      autoCloseDuration: const Duration(seconds: 3),
      showProgressBar: false,
      type: ToastificationType.success,
      icon: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: appTheme.green50Color,
        ),
        child: Icon(Icons.check, size: 16, color: appTheme.whiteColor),
      ),
    );
  }

  static showErrorDialog(String content, BuildContext context) {
    toastification.show(
      context: context,
      title: Text(content, maxLines: 3, overflow: TextOverflow.ellipsis),
      autoCloseDuration: const Duration(seconds: 3),
      showProgressBar: false,
      type: ToastificationType.error,
      icon: Icon(Icons.error, size: 24, color: appTheme.redColor),
    );
  }
}
