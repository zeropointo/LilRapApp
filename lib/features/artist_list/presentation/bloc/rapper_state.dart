part of 'rapper_bloc.dart';

/// Abstraction representing the state of the rapper bloc.
abstract class RapperState extends Equatable {
  const RapperState();

  @override
  List<Object> get props => [];
}

/// No data.
class Initial extends RapperState {}

/// Data is being retrieved.
class Loading extends RapperState {}

/// Data has been loaded.
class Loaded extends RapperState {
  final List<Rapper> rapperList;

  Loaded({required this.rapperList});

  @override
  List<Object> get props => [rapperList];
}

/// An error occured while retrieving data.
class Error extends RapperState {
  final String message;

  Error({required this.message});

  @override
  List<Object> get props => [message];
}
