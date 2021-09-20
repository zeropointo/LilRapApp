part of 'rapper_bloc.dart';

/// Abstraction representing an event recieved by the Bloc.
abstract class RapperEvent extends Equatable {
  const RapperEvent();

  @override
  List<Object> get props => [];
}

/// Event requesting a specific rapper person by id.
class GetRapperEvent extends RapperEvent {
  GetRapperEvent({required this.id});
  final String id;

  @override
  List<Object> get props => [id];
}

/// Event requesting the entire list of rapper persons.
class GetRapperListEvent extends RapperEvent {}

/// Event requesting a list of rapper persons filtered by name.
class GetFilteredRapperListEvent extends RapperEvent {
  GetFilteredRapperListEvent({required this.expression});
  final String expression;

  @override
  List<Object> get props => [expression];
}
