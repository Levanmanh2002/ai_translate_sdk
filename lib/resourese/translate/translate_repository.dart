import 'package:ai_translate/resourese/translate/itranslate_repository.dart';
import 'package:ai_translate/utils/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class TranslateRepository extends ITranslateRepository {
  @override
  Future<Response> getRoom(int id, int limit) async {
    try {
      final result = await clientGetData('${AppConstants.getRoom}$id?limit=$limit');

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> translateAudio(Map<String, dynamic> params) async {
    try {
      final result = await clientPostData(AppConstants.translateAudio, params);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> sendMessage(Map<String, dynamic> params) async {
    try {
      final result = await clientPostData(AppConstants.sendMessage, params);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
