import 'dart:convert' as convert;

import 'package:json_annotation/json_annotation.dart';

part 'instance_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class InstanceModel {
  final int? categoryId;
  final int? imageId;
  final List<List<double>>? segmentation;

  InstanceModel({required this.categoryId, required this.imageId, required this.segmentation});

  factory InstanceModel.fromJson(json) => _$InstanceModelFromJson(json);

  toJson() => _$InstanceModelToJson(this);

  static List<InstanceModel> fromJsonList(List json) {
    return json.map((e) => InstanceModel.fromJson(e)).toList();
  }
}
