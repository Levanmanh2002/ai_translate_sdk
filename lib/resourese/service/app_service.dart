import 'package:ai_translate/resourese/translate/itranslate_repository.dart';
import 'package:ai_translate/resourese/translate/translate_repository.dart';
import 'package:get/get.dart';

class AppService {
  static Future<void> initAppService() async {
    Get.put<ITranslateRepository>(TranslateRepository());
  }
}
