import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/rapper.dart';
import '../../domain/usecases/get_concrete_rapper.dart';

part 'rapper_event.dart';
part 'rapper_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server failure';
const String CACHE_FAILURE_MESSAGE = 'Cache failure';

/// Bloc consuming events and producing states.
class RapperBloc {
  RapperBloc(
      {required this.getConcreteRapper, required this.getConcreteRapperList}) {
    _rapperEventController.stream.listen(_mapEventToState);
  }

  // Usecases
  final GetConcreteRapper getConcreteRapper;
  final GetConcreteRapperList getConcreteRapperList;

  // INPUT RapperEvent SINK
  final _rapperEventController = StreamController<RapperEvent>();
  Sink<RapperEvent> get rapperEvent => _rapperEventController.sink;

  // OUTPUT RapperState STREAM
  final _rapperState = BehaviorSubject<RapperState>.seeded(Initial());
  Stream<RapperState> get rapperState => _rapperState.stream;

  Future<void> _mapEventToState(RapperEvent event) async {
    if (event is GetRapperEvent) {
      _rapperState.add(Loading());

      final failureOrRapper = await getConcreteRapper(event.id);

      _rapperState.add(failureOrRapper.fold(
        (failure) {
          return Error(message: _mapFailureToMessage(failure));
        },
        (rapper) {
          return Loaded(rapperList: [rapper]);
        },
      ));
    } else if (event is GetRapperListEvent) {
      _rapperState.add(Loading());

      final failureOrRapper = await getConcreteRapperList('_');

      _rapperState.add(failureOrRapper.fold(
        (failure) {
          return Error(message: _mapFailureToMessage(failure));
        },
        (rapperList) {
          List<Rapper> sorted = rapperList;

          sorted.sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

          return Loaded(rapperList: sorted);
        },
      ));
    } else if (event is GetFilteredRapperListEvent) {
      _rapperState.add(Loading());

      final failureOrRapper = await getConcreteRapperList('_');

      _rapperState.add(failureOrRapper.fold(
        (failure) {
          return Error(message: _mapFailureToMessage(failure));
        },
        (rapperList) {
          List<Rapper> sorted = rapperList;

          sorted.sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

          Iterable<Rapper> filtered = sorted.where((r) =>
              r.name.toLowerCase().contains(event.expression.toLowerCase()));

          return Loaded(rapperList: filtered.toList());
        },
      ));
    }
  }

  /// Maps data retrieval failure events to a message String.
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return "Unexpected failure";
    }
  }

  void dispose() {
    _rapperState.close();
    _rapperEventController.close();
  }
}
