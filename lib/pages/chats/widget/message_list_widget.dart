import 'package:ai_translate/main.dart';
import 'package:ai_translate/theme/style/style_theme.dart';
import 'package:ai_translate/utils/icons_assets.dart';
import 'package:ai_translate/widget/image_asset_custom.dart';
import 'package:flutter/material.dart';

class MessageListWidget extends StatelessWidget {
  const MessageListWidget({
    super.key,
    required this.text,
    required this.isCurrentUser,
    required this.audio,
    this.onTap,
  });

  final String text;
  final bool isCurrentUser;
  final String audio;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Align(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: BoxConstraints(maxWidth: 300),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isCurrentUser ? appTheme.appColor : appTheme.whiteColor,
            ),
            child: Column(
              mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: StyleThemeData.size14Weight400(
                    color: isCurrentUser ? appTheme.whiteColor : appTheme.blackColor,
                  ),
                ),
                if (audio.isNotEmpty) ...[
                  SizedBox(height: 4),
                  ImageAssetCustom(imagePath: IconsAssets.audioBorderIcon, size: 24),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
