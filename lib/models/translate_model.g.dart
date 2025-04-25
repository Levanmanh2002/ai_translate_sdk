// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranslateModel _$TranslateModelFromJson(Map<String, dynamic> json) =>
    TranslateModel(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : AudioData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TranslateModelToJson(TranslateModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

AudioData _$AudioDataFromJson(Map<String, dynamic> json) => AudioData(
      audio: json['audio'] as String?,
      transcript: json['transcript'] as String?,
      content: json['content'] as String?,
    );

Map<String, dynamic> _$AudioDataToJson(AudioData instance) => <String, dynamic>{
      'audio': instance.audio,
      'transcript': instance.transcript,
      'content': instance.content,
    };
