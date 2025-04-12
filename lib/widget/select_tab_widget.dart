import 'package:ai_translate/main.dart';
import 'package:ai_translate/theme/style/style_theme.dart';
import 'package:ai_translate/widget/image_asset_custom.dart';
import 'package:ai_translate/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';

class SelectTabWidget extends StatelessWidget {
  const SelectTabWidget({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.colorTitle,
    this.colorIcon,
  });

  final String icon;
  final String title;
  final VoidCallback? onTap;
  final Color? colorTitle;
  final Color? colorIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding(horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: padding(all: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: appTheme.whiteColor,
            border: Border.all(color: appTheme.border100Color),
            boxShadow: [
              BoxShadow(
                color: appTheme.blackColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              ImageAssetCustom(imagePath: icon, size: 24.w, color: colorIcon),
              SizedBox(width: 12.w),
              Text(title, style: StyleThemeData.size14Weight400(color: colorTitle)),
            ],
          ),
        ),
      ),
    );
  }
}
