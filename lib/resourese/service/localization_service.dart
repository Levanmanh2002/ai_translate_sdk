import 'package:ai_translate/language/en.dart';
import 'package:ai_translate/language/vi.dart';
import 'package:ai_translate/utils/app/app_enum.dart';
import 'package:ai_translate/utils/local_storage.dart';
import 'package:ai_translate/utils/shared_key.dart';
import 'package:get/get.dart';

class LocalizationService extends Translations {
  static Languages get language => _language;

  static const Languages fallbackLanguage = Languages.vi;

  static const List<Languages> supportedLanguage = Languages.values;

  static Languages _language = _loadSavedLanguage() ?? Languages.vi;

  // static void changeLanguage(Languages language) async {
  //   if (_language == language) return;
  //   _language = language;
  //   Get.updateLocale(language.locale);
  //   LocalStorage.setString(SharedKey.language, language.toString());
  // }

  static Languages? _loadSavedLanguage() {
    String? savedLanguageString = LocalStorage.getString(SharedKey.language);
    try {
      return Languages.values.firstWhere(
        (element) => element.toString() == savedLanguageString,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en,
        'vi_VN': vi,
      };
}

// extension LanguageExtension on Languages {
//   String get title {
//     switch (this) {
//       case Languages.vi:
//         return 'vietnamese'.tr;
//       case Languages.en:
//         return 'english'.tr;
//     }
//   }

//   Locale get locale {
//     switch (this) {
//       case Languages.vi:
//         return const Locale('vi', 'VN');
//       case Languages.en:
//         return const Locale('en', 'US');
//     }
//   }

//   // String get flagAsset {
//   //   switch (this) {
//   //     case Languages.vi:
//   //       return IconsAssets.vietnamIcon;
//   //     case Languages.en:
//   //       return IconsAssets.englandIcon;
//   //   }
//   // }
// }
