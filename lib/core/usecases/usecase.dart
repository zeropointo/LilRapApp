import 'package:dartz/dartz.dart';

import '../error/failures.dart';

/// Abstraction representing a usecase that will return either the desired object or a failure.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
