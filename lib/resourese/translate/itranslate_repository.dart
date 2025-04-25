import 'package:ai_translate/resourese/ibase_repository.dart';
import 'package:http/http.dart';

abstract class ITranslateRepository extends IBaseRepository {
  Future<Response> getRoom({required String id, required int skip, required int limit});
  Future<Response> translateAudio(Map<String, dynamic> params);
  Future<Response> sendMessage(Map<String, dynamic> params);
}
