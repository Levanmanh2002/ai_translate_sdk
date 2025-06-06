import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class ChatMessage {
  String? type;
  String? chatRoomId;
  String? content;
  String? audio;
  String? sender;
  String? createdAt;
  String? repliedFrom;
  String? forwardedFrom;
  String? mentions;
  String? id;

  ChatMessage({
    this.type,
    this.chatRoomId,
    this.content,
    this.audio,
    this.sender,
    this.createdAt,
    this.repliedFrom,
    this.forwardedFrom,
    this.mentions,
    this.id,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  static List<ChatMessage> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => ChatMessage.fromJson(json)).toList();
  }
}
