import 'package:dio/dio.dart';
import 'package:samer_orfali_test/domain/entities/caption_model.dart';
import 'package:samer_orfali_test/domain/entities/image_model.dart';
import 'package:samer_orfali_test/domain/entities/instance_model.dart';
import 'package:samer_orfali_test/domain/util/logging.dart';

import '../../domain/util/network/dio_error_handler.dart';
import '../../domain/util/network/exceptions.dart';
import '../../domain/util/network/logger_interceptor.dart';

/// The data layer, its responsibility is to deal directly with the raw data from data sources (REST API)
/// The raw data then will be mapped or converted into models
class CocoApi {
  final String _baseUrl = 'https://us-central1-open-images-dataset.cloudfunctions.net/coco-dataset-bigquery';

  final Dio _dio = Dio()

    ///add interceptors to logger requests
    ..interceptors.add(
      LoggerInterceptor(logger, request: true, requestBody: true, error: true, responseBody: true, responseHeader: false, requestHeader: true),
    );

  Future<List<int>> getImageByCategories(List<int> categories) async {
    ///request api to get imagesIds by selected categories
    try {
      var response = await _dio.post(
        _baseUrl,
        data: {
          "category_id[]": categories,
          "querytype": "getImagesByCats",
        },
      );

      ///convert data to list on int
      List<int> list = [];
      for (int i = 0; i < response.data.length; i++) {
        list.add(response.data[i]["id"]);
      }
      return list;
    } on DioError catch (e) {
      ///handling exceptions
      throw ServerException(handleDioError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<ImageModel>> getImages(List<int> imagesIds) async {
    ///request api to get images(url) models by send imagesIds
    try {
      final response = await _dio.post(
        _baseUrl,
        options: Options(headers: {"content-type": "application/x-www-form-urlencoded; charset=UTF-8"}),
        data: {
          "image_ids[]": imagesIds,
          "querytype": "getImages",
        },
      );

      ///parse json response
      return ImageModel.fromJsonList(response.data);
    } on DioError catch (e) {
      throw ServerException(handleDioError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<InstanceModel>> getInstances(List<int> imagesIds) async {
    ///request api to get instances(segmentations) models by send imagesIds

    try {
      final response = await _dio.post(
        _baseUrl,
        options: Options(headers: {"content-type": "application/x-www-form-urlencoded; charset=UTF-8"}),
        data: {
          "image_ids[]": imagesIds,
          "querytype": "getInstances",
        },
      );

      return InstanceModel.fromJsonList(response.data);
    } on DioError catch (e) {
      throw ServerException(handleDioError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<CaptionModel>> getCaptions(List<int> imagesIds) async {
    ///request api to get captions models by send imagesIds

    try {
      final response = await _dio.post(
        _baseUrl,
        options: Options(headers: {"content-type": "application/x-www-form-urlencoded; charset=UTF-8"}),
        data: {
          "image_ids[]": imagesIds,
          "querytype": "getCaptions",
        },
      );

      return CaptionModel.fromJsonList(response.data);
    } on DioError catch (e) {
      throw ServerException(handleDioError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
