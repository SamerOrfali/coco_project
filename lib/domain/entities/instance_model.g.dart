// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstanceModel _$InstanceModelFromJson(Map<String, dynamic> json) => InstanceModel(
      categoryId: json['category_id'] as int?,
      imageId: json['image_id'] as int?,
      segmentation: convert.json.decode(json['segmentation']) is List<dynamic>
          ? (convert.json.decode(json['segmentation']) as List<dynamic>).map((e) => (e as List<dynamic>).map((e) => (e as num).toDouble()).toList()).toList()
          : [],
    );

Map<String, dynamic> _$InstanceModelToJson(InstanceModel instance) => <String, dynamic>{
      'category_id': instance.categoryId,
      'image_id': instance.imageId,
      'segmentation': instance.segmentation,
    };
