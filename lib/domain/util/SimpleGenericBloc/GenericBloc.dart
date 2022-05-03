import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../failures.dart';
import 'debouncer.dart';

part 'generic_bloc_event.dart';
part 'generic_bloc_state.dart';

///Generic bloc is a bloc to provide logic for simple blocs that do async resource fetching lists with option to load more
///I made it Generic because the same case repeated in same project so I used Generic
abstract class SimpleLoaderBloc<T> extends Bloc<SimpleBlocEvent, SimpleBlocState> {
  late final ScrollController scrollController;

  SimpleLoaderBloc({required this.eventParams, this.hideLoadingAfterFirstSuccess = false}) : super(InitialState()) {
    on<LoadEvent>(_onLoad);
    on<LoadMoreEvent>(_onLoadMore);
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
  }

  final dynamic eventParams;
  final bool hideLoadingAfterFirstSuccess;

  final _debouncer = Debouncer(milliseconds: 350);

  ///when current scrolling reach the end of the screen call load more data(images) event
  void _onScroll() {
    _debouncer.run(() {
      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.position.pixels;
      if (maxScroll - currentScroll <= 50) {
        add(LoadMoreEvent(eventParams));
      }
    });
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }

  ///logic of load more event
  ///same as logic of load event but check if we reached the last item
  Future<void> _onLoadMore(LoadMoreEvent<dynamic> event, Emitter<SimpleBlocState> emit) async {
    if ((state is SuccessState && !((state as SuccessState).hasReachedMax))) {
      final result = await load(event);
      result.fold((l) {
        emit(SuccessState<T>((state as SuccessState).items, false));
      }, (r) {
        emit(SuccessState<T>(mergeItems((state as SuccessState).items, r), reachedMax()));
      });
    }
  }

  /// function that merge old data( list of items ) with new one
  /// if it is just list it means add new items to the list you have
  T mergeItems(T oldItems, T newItems);

  ///loading event logic
  ///firstly emit loading state for show loader in screen
  /// call load function
  ///then we return the response
  ///if failure => Error state
  ///if success => Success state
  _onLoad(LoadEvent event, Emitter<SimpleBlocState> emit) async {
    if (hideLoadingAfterFirstSuccess && state is SuccessState) {
      emit((state as SuccessState).copyWith(isRefreshing: true));
    } else {
      emit(LoadingState());
    }
    final result = await load(event);
    result.fold((l) {
      emit(ErrorState(l.errorMessage));
    }, (r) {
      emit(SuccessState<T>(r, reachedMax()));
    });
  }

  ///main function to load the data which connect with the repository to request to call api from data source
  Future<Either<Failure, T>> load(SimpleBlocEvent event);

  ///function to check if we reached the last item of the response list
  bool reachedMax();
}
