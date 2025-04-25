import 'dart:async';
import 'dart:developer';

import 'package:ai_translate/models/message_model.dart';
import 'package:ai_translate/models/translate_model.dart';
import 'package:ai_translate/pages/dashboard/dashboard_controller.dart';
import 'package:ai_translate/resourese/translate/itranslate_repository.dart';
import 'package:ai_translate/utils/app/app_enum.dart';
import 'package:ai_translate/utils/dialog_util.dart';
import 'package:ai_translate/utils/local_storage.dart';
import 'package:ai_translate/utils/shared_key.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatsController extends GetxController {
  final ITranslateRepository translateRepository;

  ChatsController({required this.translateRepository});

  SpeechToText speechToText = SpeechToText();

  var isListening = false.obs;
  var searchValue = ''.obs;
  var translatedText = ''.obs;

  Rx<Languages> selectedLanguage = Rx<Languages>(Languages.en);
  Rx<Languages> fromLang = Rx<Languages>(Languages.vi);

  final Map<Languages, String> languageLabels = {
    Languages.vi: 'Tiếng Việt',
    Languages.en: 'Tiếng Anh',
    Languages.th: 'Tiếng Thái',
  };

  Rx<TranslateModel?> translateModel = Rx<TranslateModel?>(null);
  RxList<ChatMessage> chatList = <ChatMessage>[].obs;
  Rx<ChatMessage?> chatMessage = Rx<ChatMessage?>(null);
  RxList<ChatMessage> messagesList = <ChatMessage>[].obs;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  var isShowScrollToBottom = false.obs;

  var isLoading = false.obs;

  final player = AudioPlayer();
  var isPlaying = false.obs;

  Timer? autoRestartTimer;
  var isReloadAudio = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMessageList();
    _initSpeech();
    _loadSavedLanguage();
    _loadSavedFromLanguage();
    itemPositionsListener.itemPositions.addListener(() {
      _scrollListener();
    });
    // _startAutoRestart();
  }

  // void _startAutoRestart() {
  //   autoRestartTimer?.cancel();
  //   autoRestartTimer = Timer.periodic(Duration(seconds: 2), (timer) {
  //     if (isReloadAudio.value == true) {
  //       if (speechToText.isListening == false) {
  //         startListening(isStartTime: false);
  //         log('Auto restart listening...');
  //       }
  //     }
  //   });
  // }

  Future<void> fetchMessageList() async {
    try {
      isLoading.value = true;
      final chatRoomId = LocalStorage.getString(SharedKey.chatRoomId);

      final response = await translateRepository.getRoom(
        id: chatRoomId,
        skip: 1,
        limit: 10,
      );

      if (response.statusCode == 200) {
        chatList.value = ChatMessage.listFromJson(response.body['messages']);
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
        Get.find<DashboardController>().login();
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

  void toggleLanguage(Languages language) {
    selectedLanguage.value = language;
    log('Selected language: ${selectedLanguage.value}');
    LocalStorage.setString(SharedKey.language, language.toString());
  }

  void toggleFromLanguage(Languages language) {
    fromLang.value = language;
    log('Selected from language: ${fromLang.value}');
    LocalStorage.setString(SharedKey.fromLanguage, language.toString());
  }

  void startListening({required bool isStartTime}) async {
    isReloadAudio.value = isStartTime;

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

  Timer? _noSpeechTimer;
  String _lastRecognizedText = '';

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

    // if (speechToText.isNotListening) {
    //   isListening.value = false;
    //   translateText();
    // } else {
    //   isListening.value = true;
    // }

    if (result.finalResult) {
      // NGƯỜI DÙNG VỪA NGỪNG NÓI
      // => Gửi đoạn text đi dịch
      log('Final result: ${result.recognizedWords}');
      log('Final result: ${result.finalResult}');
    }
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    isListening.value = false;
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

      final response = await translateRepository.translateAudio(params);

      if (response.body['status'] == 200) {
        translateModel.value = TranslateModel.fromJson(response.body);

        if (translateModel.value?.status == 200) {
          // chatList.insert(
          //   0,
          //   ChatMessage(
          //     type: 'T',
          //     chatRoomId: '67f4ac3a5621c2002728d7ee',
          //     content: translateModel.value?.data?.transcript,
          //     audio: translateModel.value?.data?.audio,
          //     sender: '19727',
          //     createdAt: DateTime.now().toString(),
          //   ),
          // );
          onSendMessage();
          // await playOrPause(translateModel.value?.data?.audio ?? '');
        }
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
        startListening(isStartTime: true);
      }
    } catch (e) {
      print(e);
      startListening(isStartTime: true);
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

      final response = await translateRepository.sendMessage(params);

      if (response.statusCode == 200) {
        chatMessage.value = ChatMessage.fromJson(response.body['data']['new_message']);
        if (chatMessage.value != null) {
          await LocalStorage.setString(SharedKey.chatRoomId, chatMessage.value?.chatRoomId ?? '');
        }
        chatList.insert(
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
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      log('Error sending message: $e');
    } finally {
      await playOrPause(translateModel.value?.data?.audio ?? '');
      startListening(isStartTime: true);
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

  @override
  void dispose() {
    super.dispose();
    player.dispose();
    autoRestartTimer?.cancel();
  }

  @override
  void onClose() {
    super.onClose();
    player.dispose();
    player.stop();
    autoRestartTimer?.cancel();
  }
}
