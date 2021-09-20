import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/rapper.dart';
import '../../domain/repositories/rapper_repo.dart';
import '../models/rapper_model.dart';
import '../sources/rapper_local_source.dart';
import '../sources/rapper_remote_source.dart';

/// Repository used for retrieving rapper data from either the network or cache.
///
/// Returns either the requested object(s) or a failure.
class RapperRepoImpl implements RapperRepo {
  RapperRepoImpl(
      {required this.remoteSource,
      required this.localSource,
      required this.networkInfo});

  final RapperRemoteSource remoteSource;
  final RapperLocalSource localSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<Rapper>>> getConcreteRapperList() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRapperList = await remoteSource.getConcreteRapperList();
        localSource.cacheRapperList(remoteRapperList);
        return Right(remoteRapperList);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final localRapperList = await localSource.getLastRapperList();
        return Right(localRapperList);
      } on Exception catch (e) {
        return Left(CacheFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, Rapper>> getConcreteRapper(String id) async {
    final Either<Failure, List<Rapper>> result = await getConcreteRapperList();

    if (result.isLeft()) return result.fold((l) => Left(l), (r) => Right(r[0]));

    List<Rapper> list = result.getOrElse(() => []);

    if (list.isEmpty) {
      return Left(ServerFailure());
    } else {
      final Rapper rapper = list.firstWhere((rapper) => rapper.id == id,
          orElse: () => RapperModel(
              id: '-1',
              name: 'name',
              description: 'description',
              image: 'image'));

      if (rapper.id != '-1') {
        return Right(rapper);
      } else {
        return Left(ServerFailure());
      }
    }
  }
}
