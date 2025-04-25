import 'package:ai_translate/resourese/ibase_repository.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class IAuthRepository extends IBaseRepository {
  Future<Response> login(Map<String, dynamic> params);
}
