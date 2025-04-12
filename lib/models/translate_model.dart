import 'package:json_annotation/json_annotation.dart';

part 'translate_model.g.dart';

@JsonSerializable()
class TranslateModel {
  int? status;
  String? message;
  AudioData? data;

  TranslateModel({
    this.status,
    this.message,
    this.data,
  });

  factory TranslateModel.fromJson(Map<String, dynamic> json) => _$TranslateModelFromJson(json);

  Map<String, dynamic> toJson() => _$TranslateModelToJson(this);
}

@JsonSerializable()
class AudioData {
  String? audio;
  String? transcript;

  AudioData({
    this.audio,
    this.transcript,
  });

  factory AudioData.fromJson(Map<String, dynamic> json) => _$AudioDataFromJson(json);

  Map<String, dynamic> toJson() => _$AudioDataToJson(this);
}
