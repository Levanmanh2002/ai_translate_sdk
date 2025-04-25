import 'package:ai_translate/models/message_model.dart';
import 'package:ai_translate/pages/chats/widget/message_list_widget.dart';
import 'package:ai_translate/utils/local_storage.dart';
import 'package:ai_translate/utils/shared_key.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({
    super.key,
    required this.chatList,
    required this.itemScrollController,
    required this.itemPositionsListener,
    required this.playOrPause,
  });

  final List<ChatMessage> chatList;
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;
  final Function(String) playOrPause;

  @override
  Widget build(BuildContext context) {
    final data = chatList;
    if (data.isEmpty) {
      return const SizedBox();
    }

    return ScrollablePositionedList.builder(
      itemCount: data.length,
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
      reverse: true,
      itemBuilder: (context, int index) {
        final item = data[index];

        final List<dynamic> originalList = LocalStorage.getJSON(SharedKey.chatMessage) as List<dynamic>? ?? [];

        final originalItem = originalList.firstWhere(
          (e) => e['id'] == item.id,
          orElse: () => null,
        );

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
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
                  await playOrPause(item.audio ?? '');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
