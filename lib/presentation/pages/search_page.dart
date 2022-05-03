import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samer_orfali_test/data/data_sources/coco_api.dart';
import 'package:samer_orfali_test/domain/entities/caption_model.dart';
import 'package:samer_orfali_test/domain/entities/image_model.dart';
import 'package:samer_orfali_test/domain/entities/instance_model.dart';
import 'package:samer_orfali_test/domain/util/SimpleGenericBloc/GenericBloc.dart';
import 'package:samer_orfali_test/presentation/bloc/search_bloc.dart';
import 'package:samer_orfali_test/presentation/pages/widgets.dart/caption_widget.dart';
import 'package:samer_orfali_test/presentation/pages/widgets.dart/category_icon_widget.dart';
import 'package:samer_orfali_test/presentation/pages/widgets.dart/image.dart';
import 'package:samer_orfali_test/presentation/pages/widgets.dart/loading_widget.dart';
import 'package:samer_orfali_test/presentation/pages/widgets.dart/search_bar.dart';

import '../../data/repositories/coco_repo_empl.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ///get bloc instance to add event and listen to state changes
  final SearchBloc searchBloc = SearchBloc(cocoRepository: CocoRepositoryImpl(cocoApi: CocoApi()));
  ///curr selected categories
  List<int> selectedCategoriesIds = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 30),
            ///wrap widget to displays its children in multiple horizontal line
            Wrap(
              children: List.generate(
                10,
                (index) => CategoryIconWidget(
                  id: index + 1,
                  selected: selectedCategoriesIds.contains(index + 1),
                  onTap: (id) => onTapCategory(id),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                SearchBar(
                  selectedCategories: selectedCategoriesIds,
                  onTap: (id) => removeCategory(id),
                ),
                const SizedBox(width: 10),
                ///here the main event called when user tap search we called load event of search bloc
                ///define the type of it as List<int< because selectedCategories is List<int>
                ///and pass it as params because the bloc need it
                InkWell(
                  onTap: () {
                    searchBloc.add(LoadEvent<List<int>>(selectedCategoriesIds));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueAccent,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Text(
                      'Search',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder(
                bloc: searchBloc,
                builder: (context, state) {
                  if (state is SuccessState) {
                    /// a snackbar to alert the user that the image can scroll horizontally
                    /// it called just one time after first response
                    if (_showNoteSnackBar) {
                      showSnackBar();
                    }
                    ///state.items is the Map that come from return of load function at search bloc when state is sucess
                    ///state.items is Map contains (images,captions,instances)
                    Map<String, dynamic> data = state.items;
                    List<ImageModel> images = data['images'] ?? [];
                    return ListView.builder(
                      controller: searchBloc.scrollController,
                      /// I added +1 to items length to add loading widget after the last items when calling load more
                      /// but if it has reached max then no need for loading widget
                      itemCount: images.length + (state.hasReachedMax ? 0 : 1),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index == images.length) {
                          return const LoadingWidget();
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CaptionWidget(captions: getCaptionsTextWidgets(data['captions'] ?? [], images[index].id)),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  ///make the image scroll able horizontally because the width of images bigger than the size of mobile screen
                                  ///and to see all detected objects clearly
                                  Expanded(
                                    child: ScrollConfiguration(
                                      behavior: const ScrollBehavior().copyWith(overscroll: false),
                                      child: SingleChildScrollView(
                                        physics: const PageScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        child: ImageWidget(
                                          url: images[index].cocoUrl,
                                          coloredPixel: getSegmentation(data['instances'] ?? [], images[index].id),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  if (state is LoadingState) {
                    return const Center(
                      child: LoadingWidget(),
                    );
                  }
                  if (state is ErrorState) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.error, style: const TextStyle(fontSize: 16, color: Colors.black)),
                        IconButton(
                          onPressed: () {
                            searchBloc.add(LoadEvent<List<int>>(selectedCategoriesIds));
                          },
                          icon: const Icon(Icons.refresh, size: 20),
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///function to put all segmentation of single image together because in api response we get all segmentations and with image id
  ///and also there is more than one segmentation for same pic
  List<double> getSegmentation(List<InstanceModel> instances, int imageId) {
    List<double> seg = [];
    for (InstanceModel ins in instances) {
      if (ins.imageId == imageId) {
        for (var inst in ins.segmentation!) {
          seg.addAll(inst);
          ///here is the magic
          ///I added -1 just to separate every object segmentation in same pic and don't draw it all in onle line as a single object
          ///I add it twice because when I convert this double to point I iterate i+=2
          seg.add(-1);
          seg.add(-1);
        }
      }
    }
    return seg;
  }

  /// convert list of captions model to list of text widget to display
  /// because also the response of get captions is not defined as for every image all captions of it no
  /// I need to iterate over all captions and check if the image id of this caption is the same of current image id
  List<Widget> getCaptionsTextWidgets(List<CaptionModel> captions, int imageId) {
    List<Widget> list = [];
    for (CaptionModel cap in captions) {
      if (cap.imageId == imageId) {
        list.add(Text(cap.caption, style: const TextStyle(fontSize: 16)));
      }
    }
    return list;
  }

  /// when tap category when it's not selected, function add it to selectedCategories
  /// when tap category when it's selected, function remove it from selectedCategories
  onTapCategory(int id) {
    if (selectedCategoriesIds.contains(id)) {
      selectedCategoriesIds.remove(id);
    } else {
      selectedCategoriesIds.add(id);
    }
    setState(() {});
  }

  ///function to remove category when tap x at specific category from search bar
  void removeCategory(int id) {
    selectedCategoriesIds.remove(id);
    setState(() {});
  }

  bool _showNoteSnackBar = true;

  void showSnackBar() {
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can scroll images horizontally!'),
          duration: Duration(seconds: 10),
        ),
      ),
    );
    _showNoteSnackBar = false;
  }
}

///id to category from CoCo website
var idToCat = {
  1: 'person',
  2: 'bicycle',
  3: 'car',
  4: 'motorcycle',
  5: 'airplane',
  6: 'bus',
  7: 'train',
  8: 'truck',
  9: 'boat',
  10: 'traffic light',
};
