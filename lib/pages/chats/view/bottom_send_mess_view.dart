import 'package:ai_translate/main.dart';
import 'package:ai_translate/theme/style/style_theme.dart';
import 'package:ai_translate/utils/app/app_enum.dart';
import 'package:ai_translate/utils/images_assets.dart';
import 'package:ai_translate/widget/image_asset_custom.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class BottomSendMessView extends StatelessWidget {
  const BottomSendMessView({
    super.key,
    required this.isListening,
    required this.startListening,
    required this.stopListening,
    required this.selectedLanguage,
    required this.fromLang,
    required this.toggleFromLanguage,
    required this.languageLabels,
  });

  final bool? isListening;
  final VoidCallback startListening;
  final VoidCallback stopListening;
  final Languages selectedLanguage;
  final Languages fromLang;
  final Function(Languages) toggleFromLanguage;
  final Map<Languages, String> languageLabels;

  @override
  Widget build(BuildContext context) {
    final fromLangItems = Languages.values.where((lang) => lang != selectedLanguage).toList();

    return Padding(
      padding: EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: null, icon: SizedBox()),
          IconButton(
            onPressed: isListening == false ? startListening : stopListening,
            icon: isListening == true
                ? ImageAssetCustom(imagePath: ImagesAssets.voiceImage, size: 100)
                : ImageAssetCustom(imagePath: ImagesAssets.voiceOpacityImage, size: 68),
          ),
          SizedBox(
            height: 40,
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<Languages>(
                value: fromLang,
                items: fromLangItems.map((lang) {
                  return DropdownMenuItem<Languages>(
                    value: lang,
                    child: Text(
                      languageLabels[lang] ?? '',
                      style: StyleThemeData.size14Weight400(),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    toggleFromLanguage(value);
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
        ],
      ),
    );
  }
}
