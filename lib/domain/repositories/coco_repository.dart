import 'package:dartz/dartz.dart';
import 'package:samer_orfali_test/domain/entities/caption_model.dart';
import 'package:samer_orfali_test/domain/entities/image_model.dart';
import 'package:samer_orfali_test/domain/entities/instance_model.dart';

import '../util/failures.dart';

///we define the repository as abstracted class in the domain layer.
abstract class CocoRepository {
  Future<Either<Failure, List<int>>> getImageByCategories(List<int> categories);

  Future<Either<Failure, List<ImageModel>>> getImages(List<int> imagesIds);

  Future<Either<Failure, List<InstanceModel>>> getInstances(List<int> imagesIds);

  Future<Either<Failure, List<CaptionModel>>> getCaptions(List<int> imagesIds);
}
