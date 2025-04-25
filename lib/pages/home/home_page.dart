import 'dart:convert';
import 'dart:developer';

import 'package:ai_translate/main.dart';
import 'package:ai_translate/pages/chats/chats_page.dart';
import 'package:ai_translate/resourese/service/app_service.dart';
import 'package:ai_translate/theme/style/style_theme.dart';
import 'package:ai_translate/utils/icons_assets.dart';
import 'package:ai_translate/utils/local_storage.dart';
import 'package:ai_translate/utils/shared_key.dart';
import 'package:ai_translate/widget/select_tab_widget.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:headset_connection_event/headset_event.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isHeadphoneConnected = false;
  var headphoneName = '';

  @override
  void initState() {
    super.initState();
    _login();
    initHeadsetEvent();
  }

  void _login() async {
    try {
      Map<String, String> params = {
        "email": "hvmq1333@gmail.com",
        "password": "@Qq123456",
        "device": "1234",
      };

      final response = await AppService().authRepo.login(params);

      if (response.statusCode == 200) {
        await LocalStorage.remove(SharedKey.token);
        await LocalStorage.setString(SharedKey.token, jsonDecode(response.body)['token']);
      }
    } catch (e) {
      print(e);
    }
  }

  void initHeadsetEvent() {
    HeadsetEvent headsetPlugin = HeadsetEvent();

    headsetPlugin.getCurrentState.then((val) {
      if (val == HeadsetState.CONNECT) {
        isHeadphoneConnected = true;
      } else if (val == HeadsetState.DISCONNECT) {
        isHeadphoneConnected = false;
      }
      setState(() {});
      log("🔊 Bluetooth đã được kết nối headset_connection_event: ${val.toString()}");
    });

    headsetPlugin.setListener((val) {
      setState(() {
        if (val == HeadsetState.CONNECT) {
          isHeadphoneConnected = true;
        } else if (val == HeadsetState.DISCONNECT) {
          isHeadphoneConnected = false;
        }
      });
      log("🔊 Bluetooth đã được kết nối4: ${val.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isHeadphoneConnected
                ? Column(
                    children: [
                      Icon(Icons.headset, size: 100, color: appTheme.succussColor),
                    ],
                  )
                : Column(
                    children: [
                      Icon(Icons.headset_off, size: 100, color: appTheme.redColor),
                      SizedBox(height: 10),
                      Text(
                        "Chưa kết nối tai nghe!",
                        style: StyleThemeData.size18Weight700(color: appTheme.redColor),
                      ),
                    ],
                  ),
            SizedBox(height: 24),
            if (!isHeadphoneConnected) ...[
              ElevatedButton(
                onPressed: () {
                  AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
                },
                child: Text(isHeadphoneConnected ? "Ngắt kết nối" : "Kết nối tai nghe"),
              ),
            ] else ...[
              SelectTabWidget(
                icon: IconsAssets.chatsIcon,
                title: 'Chế độ đối thoại AI',
                // onTap: () => Get.toNamed(Routes.CHATS),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatPage()),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
