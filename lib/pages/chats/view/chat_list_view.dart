import 'package:ai_translate/pages/chats/chats_controller.dart';
import 'package:ai_translate/pages/chats/widget/message_list_widget.dart';
import 'package:ai_translate/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatListView extends GetView<ChatsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.translateList;
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

          return Padding(
            padding: padding(horizontal: 12, vertical: 2),
            child: MessageListWidget(
              text: item.data?.transcript ?? '',
              audio: item.data?.audio ?? '',
              isCurrentUser: true,
              onTap: () async {
                if (item.data?.audio == null || item.data?.audio == '') {
                  return;
                }
                await controller.playOrPause(item.data?.audio ?? '');
              },
            ),
          );
        },
      );
    });
  }
}
