import 'package:ai_translate/resourese/auth/auth_repository.dart';
import 'package:ai_translate/resourese/translate/translate_repository.dart';

class AppService {
  static final AppService _instance = AppService._internal();
  factory AppService() => _instance;
  AppService._internal();

  final TranslateRepository translateRepo = TranslateRepository();
  final AuthRepository authRepo = AuthRepository();
}
