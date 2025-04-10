import 'package:ai_translate/resourese/ibase_repository.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class ITranslateRepository extends IBaseRepository {
  Future<Response> getRoom(int id, int limit);
  Future<Response> translateAudio(Map<String, dynamic> params);
  Future<Response> sendMessage(Map<String, dynamic> params);
}
