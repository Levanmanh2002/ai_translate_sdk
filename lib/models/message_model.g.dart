// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      type: json['type'] as String?,
      chatRoomId: json['chatRoomId'] as String?,
      content: json['content'] as String?,
      sender: json['sender'] as String?,
      createdAt: json['createdAt'] as String?,
      repliedFrom: json['repliedFrom'] as String?,
      forwardedFrom: json['forwardedFrom'] as String?,
      mentions: json['mentions'] as String?,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'type': instance.type,
      'chatRoomId': instance.chatRoomId,
      'content': instance.content,
      'sender': instance.sender,
      'createdAt': instance.createdAt,
      'repliedFrom': instance.repliedFrom,
      'forwardedFrom': instance.forwardedFrom,
      'mentions': instance.mentions,
      'id': instance.id,
    };
