// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'caption_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CaptionModel _$CaptionModelFromJson(Map<String, dynamic> json) => CaptionModel(
      caption: json['caption'] as String,
      imageId: json['image_id'] as int,
    );

Map<String, dynamic> _$CaptionModelToJson(CaptionModel instance) => <String, dynamic>{
      'caption': instance.caption,
      'image_id': instance.imageId,
    };
