// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageModel _$ImageModelFromJson(Map<String, dynamic> json) => ImageModel(
      id: json['id'] as int,
      cocoUrl: json['coco_url'] as String,
      flickrUrl: json['flickr_url'] as String,
    );

Map<String, dynamic> _$ImageModelToJson(ImageModel instance) => <String, dynamic>{
      'id': instance.id,
      'coco_url': instance.cocoUrl,
      'flickr_url': instance.flickrUrl,
    };
