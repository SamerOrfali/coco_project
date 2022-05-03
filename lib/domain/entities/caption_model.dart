import 'package:json_annotation/json_annotation.dart';

part 'caption_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CaptionModel {
  final String caption;
  final int imageId;

  CaptionModel({required this.caption, required this.imageId});

  factory CaptionModel.fromJson(json) => _$CaptionModelFromJson(json);

  toJson() => _$CaptionModelToJson(this);

  static List<CaptionModel> fromJsonList(List json) {
    return json.map((e) => CaptionModel.fromJson(e)).toList();
  }
}
