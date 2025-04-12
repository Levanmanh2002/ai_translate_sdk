import 'dart:developer';

import 'package:ai_translate/models/message_model.dart';
import 'package:ai_translate/models/translate_model.dart';
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

  Rx<Languages> selectedLanguage = Rx<Languages>(Languages.vi);

  final Map<Languages, String> languageLabels = {
    Languages.vi: 'Tiếng Việt',
    Languages.en: 'Tiếng Anh',
    Languages.th: 'Tiếng Thái',
  };

  Rx<TranslateModel?> translateModel = Rx<TranslateModel?>(null);
  RxList<TranslateModel> translateList = <TranslateModel>[].obs;
  Rx<ChatMessage?> chatMessage = Rx<ChatMessage?>(null);
  RxList<ChatMessage> messagesList = <ChatMessage>[].obs;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  var isShowScrollToBottom = false.obs;

  var isLoading = false.obs;

  final player = AudioPlayer();
  var isPlaying = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
    _loadSavedLanguage();
    itemPositionsListener.itemPositions.addListener(() {
      _scrollListener();
    });
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
    if (speechToText.isNotListening) {
      isListening.value = false;
      translateText();
    } else {
      isListening.value = true;
    }
  }

  void stopListening() async {
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

      Map<String, String> params = {
        'text': searchValue.value,
        'from-lang': Languages.vi.value,
        'to-lang': selectedLanguage.value.value,
        'gender': 'female',
      };

      final response = await translateRepository.translateAudio(params);

      if (response.statusCode == 200) {
        translateModel.value = TranslateModel.fromJson(response.body);

        if (translateModel.value?.status == 200) {
          // translateList.add(translateModel.value!);
          translateList.insert(0, translateModel.value!);
          onSendMessage();
        }
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void onSendMessage() async {
    try {
      Map<String, String> params = {
        'email': 'hvmq1333@gmail.com',
        'message': translateModel.value?.data?.transcript ?? '',
        'bot_nickname': 'ai_translate',
      };

      final response = await translateRepository.sendMessage(params);

      if (response.statusCode == 200) {
        chatMessage.value = ChatMessage.fromJson(response.body['data']['new_message']);
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      log('Error sending message: $e');
    }
  }

  Future<void> playOrPause(String url) async {
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
  }

  @override
  void onClose() {
    super.onClose();
    player.dispose();
    player.stop();
  }
}
