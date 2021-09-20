import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/rapper.dart';
import '../../domain/usecases/get_concrete_rapper.dart';

part 'rapper_event.dart';
part 'rapper_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server failure';
const String CACHE_FAILURE_MESSAGE = 'Cache failure';

/// Bloc serivicing requests for Rapper data.
class RapperBloc extends Bloc<RapperEvent, RapperState> {
  RapperBloc(
      {required this.getConcreteRapper, required this.getConcreteRapperList})
      : super(Initial());

  final GetConcreteRapper getConcreteRapper;
  final GetConcreteRapperList getConcreteRapperList;

  /// Handles incomming events.
  @override
  Stream<RapperState> mapEventToState(
    RapperEvent event,
  ) async* {
    if (event is GetRapperEvent) {
      yield Loading();

      final failureOrRapper = await getConcreteRapper(event.id);

      yield* failureOrRapper.fold(
        (failure) async* {
          yield Error(message: _mapFailureToMessage(failure));
        },
        (rapper) async* {
          yield Loaded(rapperList: [rapper]);
        },
      );
    } else if (event is GetRapperListEvent) {
      yield Loading();

      final failureOrRapper = await getConcreteRapperList('_');

      yield* failureOrRapper.fold(
        (failure) async* {
          yield Error(message: _mapFailureToMessage(failure));
        },
        (rapperList) async* {
          List<Rapper> sorted = rapperList;

          sorted.sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

          yield Loaded(rapperList: sorted);
        },
      );
    } else if (event is GetFilteredRapperListEvent) {
      yield Loading();

      final failureOrRapper = await getConcreteRapperList('_');

      yield* failureOrRapper.fold(
        (failure) async* {
          yield Error(message: _mapFailureToMessage(failure));
        },
        (rapperList) async* {
          List<Rapper> sorted = rapperList;

          sorted.sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

          Iterable<Rapper> filtered = sorted.where((r) =>
              r.name.toLowerCase().contains(event.expression.toLowerCase()));

          yield Loaded(rapperList: filtered.toList());
        },
      );
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
}
