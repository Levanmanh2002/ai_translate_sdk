import 'package:ai_translate/pages/chats/chats_controller.dart';
import 'package:ai_translate/pages/chats/widget/message_list_widget.dart';
import 'package:ai_translate/utils/local_storage.dart';
import 'package:ai_translate/utils/shared_key.dart';
import 'package:ai_translate/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatListView extends GetView<ChatsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.chatList;
      if (data.isEmpty) {
        return const SizedBox();
      }

      return ScrollablePositionedList.builder(
        itemCount: data.length,
        itemScrollController: controller.itemScrollController,
        itemPositionsListener: controller.itemPositionsListener,
        reverse: true,
        itemBuilder: (context, int index) {
          final item = data[index];

          final List<dynamic> originalList = LocalStorage.getJSON(SharedKey.chatMessage) as List<dynamic>? ?? [];

          final originalItem = originalList.firstWhere(
            (e) => e['id'] == item.id,
            orElse: () => null,
          );

          return Padding(
            padding: padding(horizontal: 12, vertical: 2),
            child: Column(
              children: [
                if (originalItem != null)
                  MessageListWidget(
                    text: '${originalItem['text']}',
                    audio: '',
                    isCurrentUser: true,
                  ),
                MessageListWidget(
                  text: item.content ?? '',
                  audio: item.audio ?? '',
                  isCurrentUser: false,
                  onTap: () async {
                    if (item.audio == null || item.audio == '') {
                      return;
                    }
                    await controller.playOrPause(item.audio ?? '');
                  },
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
