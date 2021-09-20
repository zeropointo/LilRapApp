import 'package:equatable/equatable.dart';

/// Abstraction representing a failure of some type. Used in lieu of throwing an error.
abstract class Failure extends Equatable {
  Failure([this.properties = const <dynamic>[]]);

  final List properties;

  @override
  List<Object?> get props => properties;
}

/// Failure used for network or endpoint failures of some type.
class ServerFailure extends Failure {
  ServerFailure([this.message = "A server failure occured"]);
  final String message;
}

/// Failure used for cache failures of some kind.
class CacheFailure extends Failure {
  CacheFailure([this.message = "A cache failure occured"]);
  final String message;
}
