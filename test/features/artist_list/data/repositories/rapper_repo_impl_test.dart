import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lil_rap_app/core/error/exceptions.dart';
import 'package:lil_rap_app/core/error/failures.dart';
import 'package:lil_rap_app/core/network/network_info.dart';
import 'package:lil_rap_app/features/artist_list/data/models/rapper_model.dart';
import 'package:lil_rap_app/features/artist_list/data/repositories/rapper_repo_impl.dart';
import 'package:lil_rap_app/features/artist_list/data/sources/rapper_local_source.dart';
import 'package:lil_rap_app/features/artist_list/data/sources/rapper_remote_source.dart';
import 'package:lil_rap_app/features/artist_list/domain/entities/rapper.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'rapper_repo_impl_test.mocks.dart';

@GenerateMocks([RapperRemoteSource, RapperLocalSource, NetworkInfo])
void main() {
  late RapperRepoImpl repository;
  late MockRapperRemoteSource mockRapperRemoteSource;
  late MockRapperLocalSource mockRapperLocalSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRapperRemoteSource = MockRapperRemoteSource();
    mockRapperLocalSource = MockRapperLocalSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = RapperRepoImpl(
      remoteSource: mockRapperRemoteSource,
      localSource: mockRapperLocalSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getConcreteRapper', () {
    final id = 'c3398b59-d654-4fd5-a595-fdf3cd13a1f0';
    final rapperModel = [
      RapperModel(
          id: id,
          name: 'Lil Derivative',
          description:
              'The best linear approximation of a Rapper type person. Unlike his name, his work is anything but derivative.',
          image: 'https://avatars.githubusercontent.com/u/90428980?v=4')
    ];
    final Rapper rapper = rapperModel[0];

    test('Should check if the devices internet connection is available',
        () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRapperRemoteSource.getConcreteRapperList())
          .thenAnswer((_) async => Future.value(rapperModel));

      repository.getConcreteRapper(id);

      verify(mockNetworkInfo.isConnected);
    });

    group('Device online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('Should return remote data when call to remote source is succesful',
          () async {
        when(mockRapperRemoteSource.getConcreteRapperList())
            .thenAnswer((_) async => Future.value(rapperModel));

        final result = await repository.getConcreteRapper(id);

        verify(mockRapperRemoteSource.getConcreteRapperList());
        expect(result, equals(Right(rapper)));
      });

      test('Should cache data when call to remote source is succesful',
          () async {
        when(mockRapperRemoteSource.getConcreteRapperList())
            .thenAnswer((_) async => rapperModel);

        await repository.getConcreteRapper(id);

        verify(mockRapperRemoteSource.getConcreteRapperList());
        verify(mockRapperLocalSource.cacheRapperList(rapperModel));
      });

      test('Should return ServerFailure when call to remote source fails',
          () async {
        when(mockRapperRemoteSource.getConcreteRapperList())
            .thenThrow(ServerException("This is just a test!"));

        final result = await repository.getConcreteRapper(id);

        verify(mockRapperRemoteSource.getConcreteRapperList());
        verifyZeroInteractions(mockRapperLocalSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    group('Device offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('Should return last cached data when it is present', () async {
        when(mockRapperLocalSource.getLastRapperList())
            .thenAnswer((_) async => rapperModel);

        final result = await repository.getConcreteRapper(id);

        verifyZeroInteractions(mockRapperRemoteSource);
        verify(mockRapperLocalSource.getLastRapperList());
        expect(result, equals(Right(rapper)));
      });

      test('Should return CacheFailure when cached data is not present',
          () async {
        when(mockRapperLocalSource.getLastRapperList())
            .thenThrow(CacheException("This is just a test!"));

        final result = await repository.getConcreteRapper(id);

        verifyZeroInteractions(mockRapperRemoteSource);
        verify(mockRapperLocalSource.getLastRapperList());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
