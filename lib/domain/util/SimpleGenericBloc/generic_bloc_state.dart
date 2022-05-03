part of 'GenericBloc.dart';

///possible simple bloc states (loading,success,failure)
abstract class SimpleBlocState {}

class LoadingState extends SimpleBlocState {
  LoadingState();
}

class InitialState extends SimpleBlocState {}

class SuccessState<T> extends SimpleBlocState {
  final T items;
  final bool hasReachedMax;
  final bool isRefreshing;

  SuccessState(this.items, this.hasReachedMax, {this.isRefreshing: false});

  SuccessState<T> copyWith({
    T? items,
    bool? hasReachedMax,
    bool? isRefreshing,
  }) {
    return SuccessState<T>(
      items ?? this.items,
      hasReachedMax ?? this.hasReachedMax,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class ErrorState extends SimpleBlocState {
  final String error;

  ErrorState(this.error);
}
