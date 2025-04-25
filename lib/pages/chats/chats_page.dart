import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:ai_translate/main.dart';
import 'package:ai_translate/models/message_model.dart';
import 'package:ai_translate/models/translate_model.dart';
import 'package:ai_translate/pages/chats/view/bottom_send_mess_view.dart';
import 'package:ai_translate/pages/chats/view/chat_list_view.dart';
import 'package:ai_translate/resourese/service/app_service.dart';
import 'package:ai_translate/theme/style/style_theme.dart';
import 'package:ai_translate/utils/app/app_enum.dart';
import 'package:ai_translate/utils/dialog_util.dart';
import 'package:ai_translate/utils/icons_assets.dart';
import 'package:ai_translate/utils/local_storage.dart';
import 'package:ai_translate/utils/shared_key.dart';
import 'package:ai_translate/widget/image_asset_custom.dart';
import 'package:app_settings/app_settings.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:headset_connection_event/headset_event.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ValueNotifier<bool> isHeadphoneConnected = ValueNotifier(false);

  SpeechToText speechToText = SpeechToText();

  ValueNotifier<bool> isListening = ValueNotifier(false);
  ValueNotifier<String> searchValue = ValueNotifier('');
  ValueNotifier<String> translatedText = ValueNotifier('');

  ValueNotifier<Languages> selectedLanguage = ValueNotifier(Languages.en);
  ValueNotifier<Languages> fromLang = ValueNotifier(Languages.vi);

  final Map<Languages, String> languageLabels = {
    Languages.vi: 'Tiếng Việt',
    Languages.en: 'Tiếng Anh',
    Languages.th: 'Tiếng Thái',
  };

  ValueNotifier<TranslateModel?> translateModel = ValueNotifier(null);
  ValueNotifier<List<ChatMessage>> chatList = ValueNotifier([]);
  ValueNotifier<ChatMessage?> chatMessage = ValueNotifier(null);
  ValueNotifier<List<ChatMessage>> messagesList = ValueNotifier([]);

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  ValueNotifier<bool> isShowScrollToBottom = ValueNotifier(false);

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  final player = AudioPlayer();
  ValueNotifier<bool> isPlaying = ValueNotifier(false);

  Timer? autoRestartTimer;

  @override
  void initState() {
    super.initState();
    fetchMessageList();
    _initSpeech();
    _loadSavedLanguage();
    _loadSavedFromLanguage();
    initHeadsetEvent();

    itemPositionsListener.itemPositions.addListener(() {
      _scrollListener();
    });
  }

  Future<void> fetchMessageList() async {
    try {
      isLoading.value = true;
      final chatRoomId = LocalStorage.getString(SharedKey.chatRoomId);

      final response = await AppService().translateRepo.getRoom(
            id: chatRoomId,
            skip: 1,
            limit: 10,
          );

      if (response.statusCode == 200) {
        chatList.value = ChatMessage.listFromJson(jsonDecode(response.body)['messages']);
      } else {
        DialogUtils.showErrorDialog(jsonDecode(response.body)['message'], context);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _loadSavedLanguage() {
    String? savedLanguageString = LocalStorage.getString(SharedKey.language);
    try {
      final language = Languages.values.firstWhere(
        (element) => element.toString() == savedLanguageString,
      );

      selectedLanguage.value = language;
    } catch (e) {
      print(e);
    }
  }

  void _loadSavedFromLanguage() {
    String? savedLanguageString = LocalStorage.getString(SharedKey.fromLanguage);
    try {
      final language = Languages.values.firstWhere(
        (element) => element.toString() == savedLanguageString,
      );

      fromLang.value = language;
    } catch (e) {
      print(e);
    }
  }

  void _initSpeech() async {
    await speechToText.initialize();
  }

  void _scrollListener() {
    final positions = itemPositionsListener.itemPositions.value;

    if (positions.isNotEmpty) {
      final minIndex = positions.map((e) => e.index).reduce((a, b) => a < b ? a : b);

      if (minIndex > 2 && !isShowScrollToBottom.value) {
        isShowScrollToBottom.value = true;
      } else if (minIndex <= 2 && isShowScrollToBottom.value) {
        isShowScrollToBottom.value = false;
      }
    }
  }

  void scrollToBottom() {
    itemScrollController.scrollTo(
      index: 0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void initHeadsetEvent() {
    HeadsetEvent headsetPlugin = HeadsetEvent();

    headsetPlugin.getCurrentState.then((val) {
      if (val == HeadsetState.CONNECT) {
        isHeadphoneConnected.value = true;
      } else if (val == HeadsetState.DISCONNECT) {
        isHeadphoneConnected.value = false;
      }
      log("🔊 Bluetooth đã được kết nối headset_connection_event: ${val.toString()}");
    });

    headsetPlugin.setListener((val) {
      if (val == HeadsetState.CONNECT) {
        isHeadphoneConnected.value = true;
      } else if (val == HeadsetState.DISCONNECT) {
        isHeadphoneConnected.value = false;
      }
      log("🔊 Bluetooth đã được kết nối4: ${val.toString()}");
    });
  }

  void toggleLanguage(Languages language) {
    selectedLanguage.value = language;
    LocalStorage.setString(SharedKey.language, language.toString());
  }

  void toggleFromLanguage(Languages language) {
    fromLang.value = language;
    LocalStorage.setString(SharedKey.fromLanguage, language.toString());
  }

  Timer? _noSpeechTimer;
  String _lastRecognizedText = '';

  void startListening() async {
    await speechToText.listen(
      onResult: _onSpeechResult,
      onSoundLevelChange: (level) {
        if (speechToText.isNotListening) {
          isListening.value = false;
        } else {
          isListening.value = true;
        }
      },
    );
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    print('result: ${result.recognizedWords}');
    searchValue.value = result.recognizedWords;
    isListening.value = !speechToText.isNotListening;

    if (result.recognizedWords != _lastRecognizedText) {
      _lastRecognizedText = result.recognizedWords;

      _noSpeechTimer?.cancel();
      _noSpeechTimer = Timer(Duration(seconds: 3), () {
        translateText();
      });
    }

    if (result.finalResult) {
      // NGƯỜI DÙNG VỪA NGỪNG NÓI
      log('Final result: ${result.recognizedWords}');
      log('Final result: ${result.finalResult}');
    }
  }

  Future<void> translateText() async {
    // final translator = GoogleTranslator();
    // var translation = await translator.translate(
    //   searchValue.value,
    //   from: 'vi',
    //   to: selectedLanguage.value.name,
    // );
    // translatedText.value = translation.text;
    // log('Translated text: ${translatedText.value}');

    try {
      isLoading.value = true;
      await player.stop();
      isPlaying.value = false;
      stopListening();

      Map<String, String> params = {
        'text': searchValue.value,
        'from-lang': fromLang.value.value,
        'to-lang': selectedLanguage.value.value,
        'gender': 'Male',
      };

      final response = await AppService().translateRepo.translateAudio(params);

      final data = jsonDecode(response.body);

      if (data['status'] == 200) {
        translateModel.value = TranslateModel.fromJson(data);

        if (translateModel.value?.status == 200) {
          onSendMessage();
        }
      } else {
        DialogUtils.showErrorDialog(data['message'], context);
        startListening();
      }
    } catch (e) {
      print(e);
      startListening();
    } finally {
      isLoading.value = false;
    }
  }

  void onSendMessage() async {
    try {
      Map<String, String> params = {
        'email': "hvmq1333@gmail.com",
        'message': translateModel.value?.data?.transcript ?? '',
        'bot_nickname': "ai_translate",
      };

      final response = await AppService().translateRepo.sendMessage(params);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        chatMessage.value = ChatMessage.fromJson(data['data']['new_message']);
        if (chatMessage.value != null) {
          await LocalStorage.setString(SharedKey.chatRoomId, chatMessage.value?.chatRoomId ?? '');
        }
        chatList.value.insert(
          0,
          ChatMessage(
            type: 'T',
            chatRoomId: '67f4ac3a5621c2002728d7ee',
            content: translateModel.value?.data?.transcript,
            audio: translateModel.value?.data?.audio,
            sender: '19727',
            createdAt: DateTime.now().toString(),
            id: chatMessage.value?.id,
          ),
        );
        saveTextOriginalLocal(searchValue.value, chatMessage.value?.id ?? '');
      } else {
        DialogUtils.showErrorDialog(data['message'], context);
      }
    } catch (e) {
      log('Error sending message: $e');
    } finally {
      await playOrPause(translateModel.value?.data?.audio ?? '');
      startListening();
    }
  }

  void saveTextOriginalLocal(String text, String id) async {
    List<dynamic> chatList = LocalStorage.getJSON(SharedKey.chatMessage) as List<dynamic>? ?? [];

    final existingIndex = chatList.indexWhere((item) => item['id'] == id);
    if (existingIndex != -1) {
      chatList[existingIndex]['text'] = text;
    } else {
      chatList.add({'id': id, 'text': text, 'isOriginal': true});
    }

    await LocalStorage.setJSON(SharedKey.chatMessage, chatList);
  }

  Future<void> playOrPause(String url) async {
    if (url.isEmpty) return;

    log('Audio URL: $url');
    if (isPlaying.value) {
      await player.stop();
      isPlaying.value = false;
    } else {
      try {
        await player.stop();

        if (player.processingState == ProcessingState.completed) {
          await player.setUrl(url);
        } else if (player.processingState == ProcessingState.idle) {
          await player.setUrl(url);
        }
        await player.play();
        isPlaying.value = true;

        player.playerStateStream.listen((state) {
          if (state.processingState == ProcessingState.completed) {
            isPlaying.value = false;
          }
        });
      } catch (e) {
        print("Error playing audio: $e");
      }
    }
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    isListening.value = false;
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
    player.stop();
    autoRestartTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.blueFFColor,
      appBar: AppBar(
        title: Text('Đối thoại AI', style: StyleThemeData.size16Weight600()),
        actions: [
          ValueListenableBuilder<Languages>(
            valueListenable: selectedLanguage,
            builder: (context, selectedLang, child) {
              final filteredLanguages = Languages.values.where((lang) => lang != fromLang.value).toList();

              if (!filteredLanguages.contains(selectedLanguage.value)) {
                selectedLanguage.value = filteredLanguages.first;
              }

              return SizedBox(
                height: 40,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<Languages>(
                    value: selectedLanguage.value,
                    items: filteredLanguages.map((lang) {
                      return DropdownMenuItem<Languages>(
                        value: lang,
                        child: Text(
                          languageLabels[lang] ?? '',
                          style: StyleThemeData.size14Weight400(),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        toggleLanguage(value);
                      }
                    },
                    iconStyleData: const IconStyleData(icon: SizedBox.shrink()),
                    buttonStyleData: ButtonStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        border: Border.all(width: 1, color: appTheme.appColor),
                        color: appTheme.whiteColor,
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: appTheme.whiteColor),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(width: 12),
        ],
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: isHeadphoneConnected,
        builder: (context, isConnected, child) {
          return isConnected
              ? Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: chatList,
                            builder: (context, chatList, child) {
                              return ChatListView(
                                chatList: chatList,
                                itemScrollController: itemScrollController,
                                itemPositionsListener: itemPositionsListener,
                                playOrPause: playOrPause,
                              );
                            },
                          ),
                          ValueListenableBuilder<bool>(
                            valueListenable: isShowScrollToBottom,
                            builder: (context, isShowScrollToBottom, child) {
                              return isShowScrollToBottom
                                  ? Positioned(
                                      bottom: 12,
                                      right: 16,
                                      child: _buildScrollToBottomMess(),
                                    )
                                  : const SizedBox();
                            },
                          ),
                          ValueListenableBuilder<bool>(
                            valueListenable: isLoading,
                            builder: (context, isLoading, child) {
                              return isLoading
                                  ? Center(child: CircularProgressIndicator(color: appTheme.appColor))
                                  : const SizedBox();
                            },
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: ValueListenableBuilder<Languages>(
                        valueListenable: selectedLanguage,
                        builder: (context, selectedLanguageValue, _) {
                          return ValueListenableBuilder(
                              valueListenable: fromLang,
                              builder: (context, fromLangValue, _) {
                                final fromLangItems =
                                    Languages.values.where((lang) => lang != selectedLanguageValue).toList();

                                if (!fromLangItems.contains(fromLangValue)) {
                                  fromLangValue = fromLangItems.first;
                                }

                                return ValueListenableBuilder(
                                  valueListenable: isListening,
                                  builder: (context, isListening, child) {
                                    return BottomSendMessView(
                                      isListening: isListening,
                                      startListening: startListening,
                                      stopListening: stopListening,
                                      selectedLanguage: selectedLanguageValue,
                                      fromLang: fromLangValue,
                                      toggleFromLanguage: toggleFromLanguage,
                                      languageLabels: languageLabels,
                                    );
                                  },
                                );
                              });
                        },
                      ),
                    ),
                  ],
                )
              : Center(
                  child: ElevatedButton(
                    onPressed: () {
                      AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
                    },
                    child: Text('Kết nối tai nghe'),
                  ),
                );
        },
      ),
    );
  }

  Widget _buildScrollToBottomMess() {
    return InkWell(
      onTap: scrollToBottom,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(shape: BoxShape.circle, color: appTheme.whiteColor),
        child: const ImageAssetCustom(imagePath: IconsAssets.doubleArrowDownIcon),
      ),
    );
  }
}
