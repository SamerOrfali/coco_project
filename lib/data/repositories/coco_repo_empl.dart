import 'package:dartz/dartz.dart';
import 'package:samer_orfali_test/domain/entities/caption_model.dart';
import 'package:samer_orfali_test/domain/entities/image_model.dart';
import 'package:samer_orfali_test/domain/entities/instance_model.dart';

import '../../domain/repositories/coco_repository.dart';
import '../../domain/util/failures.dart';
import '../../domain/util/network/exceptions.dart';
import '../data_sources/coco_api.dart';

///The data layer is also contains the real implementations of the abstraction in the domain layer including the repositories,
/// this is useful because we have the ability to change or add multiple implementations without interacting with the Domain layer.
class CocoRepositoryImpl extends CocoRepository {
  final CocoApi cocoApi;

  CocoRepositoryImpl({required this.cocoApi});

  @override
  Future<Either<Failure, List<int>>> getImageByCategories(List<int> categories) async {
    try {
      final result = await cocoApi.getImageByCategories(categories);
      ///success
      return Right(result);
    } on ServerException catch (e) {
      ///failure
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<CaptionModel>>> getCaptions(List<int> imagesIds) async {
    try {
      final result = await cocoApi.getCaptions(imagesIds);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ImageModel>>> getImages(List<int> imagesIds) async {
    try {
      final result = await cocoApi.getImages(imagesIds);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<InstanceModel>>> getInstances(List<int> imagesIds) async {
    try {
      final result = await cocoApi.getInstances(imagesIds);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
