import 'package:ai_translate/resourese/auth/iauth_repository.dart';
import 'package:ai_translate/utils/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class AuthRepository extends IAuthRepository {
  @override
  Future<Response> login(Map<String, dynamic> params) async {
    try {
      final result = await clientPostData(
        AppConstants.loginUri,
        params,
        baseUrl: AppConstants.baseUrl2,
      );

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
