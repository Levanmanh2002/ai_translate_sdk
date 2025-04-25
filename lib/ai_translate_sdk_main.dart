import 'package:ai_translate/pages/home/home_page.dart';
import 'package:ai_translate/utils/local_storage.dart';
import 'package:flutter/material.dart';

Future<Widget> initAiTranslateSdk() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();

  return HomePage();
}
