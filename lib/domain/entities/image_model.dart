import 'package:json_annotation/json_annotation.dart';

part 'image_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ImageModel {
  final int id;
  final String cocoUrl;
  final String flickrUrl;

  ImageModel({required this.id, required this.cocoUrl, required this.flickrUrl});

  factory ImageModel.fromJson(json) => _$ImageModelFromJson(json);

  toJson() => _$ImageModelToJson(this);

  static List<ImageModel> fromJsonList(List json) {
    return json.map((e) => ImageModel.fromJson(e)).toList();
  }
}
