part of 'GenericBloc.dart';

///simple bloc events
///load event for get data for first api call
///load more event for get data for load more data
abstract class SimpleBlocEvent {}

class LoadEvent<T> extends SimpleBlocEvent {
  final T params;

  LoadEvent(this.params);
}

class LoadMoreEvent<T> extends SimpleBlocEvent {
  final T params;

  LoadMoreEvent(this.params);
}
