import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:samer_orfali_test/domain/entities/caption_model.dart';
import 'package:samer_orfali_test/domain/entities/image_model.dart';
import 'package:samer_orfali_test/domain/repositories/coco_repository.dart';
import 'package:samer_orfali_test/domain/util/SimpleGenericBloc/GenericBloc.dart';
import 'package:samer_orfali_test/domain/util/failures.dart';

import '../../domain/entities/instance_model.dart';

///the main bloc for the app which do the business logic of the app
/// search bloc extends the simple loader bloc to override the methods we make
/// the type of the search bloc is Map<String, dynamic> because we want to return 3 list not just 1 list
/// we want to return (images,instances,captions) so i make it as map
/// it need repositories instance to connect with

class SearchBloc extends SimpleLoaderBloc<Map<String, dynamic>> {
  SearchBloc({
    required this.cocoRepository,
    eventParams,
  }) : super(eventParams: eventParams);
  final CocoRepository cocoRepository;
  ///imagesIds is the response of first api call which contain the ids of images of the selected categories
  List<int> _imagesIds = [];
  ///last used image id to know if we reach the last image to not call load more
  int lastImageId = 0;

  ///pagination is the number of image_id to send to api together and  get image,instances,caption
  int pagination = 10;

  @override
  Future<Either<Failure, Map<String, dynamic>>> load(SimpleBlocEvent event) async {
    if (event is LoadEvent) {
      ///get imagesIds just firstTime by api request
      ///we add this condition because load is called at first load and at every load more
      ///if success then we request to get images,instances,captions for the images ids
      final imagesIdsRes = await cocoRepository.getImageByCategories(event.params);
      return imagesIdsRes.fold((l) => Left(ServerFailure(l.errorMessage)), (r) {
        _imagesIds = r;
        return getData();
      });
    } else {
      /// if event is load more so we just need to get data (image,instances,captions)
      return getData();
    }
  }

  ///the function to get data (image,instances,captions)
  ///each one of them need a specific api
  ///and also we need to check failure for each response
  ///and if all success then we return a map contains (images,instances,captions)
  Future<Either<Failure, Map<String, dynamic>>> getData() async {
    Map<String, dynamic> result = {};

    ///get the current images id starting with last image index called ending with last image index + pagination number
    List<int> currImagesIds = _imagesIds.sublist(lastImageId, min(lastImageId + pagination, _imagesIds.length));
    ///check if the remain images is less than pagination number (now is 10)
    lastImageId = min(lastImageId + pagination, _imagesIds.length);
    final imagesRes = await cocoRepository.getImages(currImagesIds);
    return imagesRes.fold((l) => Left(ServerFailure(l.errorMessage)), (images) async {
      result['images'] = images;
      final instancesRes = await cocoRepository.getInstances(currImagesIds);
      return instancesRes.fold((l) => Left(ServerFailure(l.errorMessage)), (instances) async {
        result['instances'] = instances;
        final captionsRes = await cocoRepository.getCaptions(currImagesIds);
        return captionsRes.fold((l) => Left(ServerFailure(l.errorMessage)), (captions) {
          result['captions'] = captions;
          ///we wait for all requests to complete and get response
          ///if all success then we return map contains 3 list (image,instances,captions)
          return Right(result);
        });
      });
    });
  }

  ///check if the last image index we send to api is same of the length of imagesIds so I reached the last item and no need for load more
  @override
  bool reachedMax() {
    return lastImageId == _imagesIds.length;
  }

  ///function to merge old state response(in our case is map but default is list) with the new one
  @override
  Map<String, dynamic> mergeItems(Map<String, dynamic> oldItems, Map<String, dynamic> newItems) {
    List<InstanceModel> instances = oldItems['instances'] ?? [];
    instances.addAll(newItems['instances'] ?? []);
    List<CaptionModel> captions = oldItems['captions'] ?? [];
    captions.addAll(newItems['captions'] ?? []);
    List<ImageModel> images = oldItems['images'] ?? [];
    images.addAll(newItems['images'] ?? []);
    ///return map contains the old data and new data together
    return {
      'instances': instances,
      'captions': captions,
      'images': images,
    };
  }
}
