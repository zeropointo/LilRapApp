import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/rapper.dart';
import '../repositories/rapper_repo.dart';

/// Callable class that retrieves a single Rapper object by unique id.
class GetConcreteRapper implements UseCase<Rapper, String> {
  GetConcreteRapper(this.repository);

  final RapperRepo repository;

  @override
  Future<Either<Failure, Rapper>> call(String uuid) async {
    return await repository.getConcreteRapper(uuid);
  }
}

/// Callable class that retrieves a List of Rapper objects.
class GetConcreteRapperList implements UseCase<List<Rapper>, dynamic> {
  GetConcreteRapperList(this.repository);

  final RapperRepo repository;

  @override
  Future<Either<Failure, List<Rapper>>> call(_) async {
    return await repository.getConcreteRapperList();
  }
}
