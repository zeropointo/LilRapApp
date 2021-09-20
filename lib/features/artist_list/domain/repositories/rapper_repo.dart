import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/rapper.dart';

/// Abstraction representing a repository that does not propigate Exceptions beyond the data layer.
abstract class RapperRepo {
  /// Retrieves either a List<Rapper> or a Failure.
  Future<Either<Failure, List<Rapper>>> getConcreteRapperList();

  /// Retrieves either a specific Rapper or a Failure.
  Future<Either<Failure, Rapper>> getConcreteRapper(String id);
}
