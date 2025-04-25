import 'package:ai_translate/resourese/ibase_repository.dart';
import 'package:http/http.dart';

abstract class IAuthRepository extends IBaseRepository {
  Future<Response> login(Map<String, dynamic> params);
}
