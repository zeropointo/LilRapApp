import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lil_rap_app/core/error/failures.dart';
import 'package:lil_rap_app/features/artist_list/domain/entities/rapper.dart';
import 'package:lil_rap_app/features/artist_list/domain/usecases/get_concrete_rapper.dart';
import 'package:lil_rap_app/features/artist_list/presentation/bloc/rapper_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'rapper_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteRapperList, GetConcreteRapper])
void main() {
  late MockGetConcreteRapper mockGetConcreteRapper;
  late MockGetConcreteRapperList mockGetConcreteRapperList;
  late RapperBloc rapperBloc;

  setUp(() {
    mockGetConcreteRapper = MockGetConcreteRapper();
    mockGetConcreteRapperList = MockGetConcreteRapperList();

    rapperBloc = RapperBloc(
        getConcreteRapper: mockGetConcreteRapper,
        getConcreteRapperList: mockGetConcreteRapperList);
  });

  test('Initial state should be Initial', () async {
    RapperState result = await rapperBloc.rapperState.first;
    expect(result, equals(Initial()));
  });

  group('GetConcreteRapper', () {
    final id = 'c3398b59-d654-4fd5-a595-fdf3cd13a1f0';
    final rapperModel = Rapper(
        id: id,
        name: 'Lil Derivative',
        description:
            'The best linear approximation of a Rapper type person. Unlike his name, his work is anything but derivative.',
        image: 'https://avatars.githubusercontent.com/u/90428980?v=4');

    test('Should get a Rapper from the getConcreteRapper UseCase', () async {
      when(mockGetConcreteRapper(any))
          .thenAnswer((_) async => Right(rapperModel));

      rapperBloc.rapperEvent.add(GetRapperEvent(id: id));
      await untilCalled(mockGetConcreteRapper(id));

      verify(mockGetConcreteRapper(id));
    });

    test('Should emit Loading then Loaded when data is retrieved', () async {
      when(mockGetConcreteRapper(any))
          .thenAnswer((_) async => Right(rapperModel));

      final expected = [
        Initial(),
        Loading(),
        Loaded(rapperList: [rapperModel])
      ];

      expectLater(rapperBloc.rapperState, emitsInOrder(expected));

      rapperBloc.rapperEvent.add(GetRapperEvent(id: id));
    });

    test('Should emit Loading then Error when server request fails', () async {
      when(mockGetConcreteRapper(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        Initial(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];

      expectLater(rapperBloc.rapperState, emitsInOrder(expected));

      rapperBloc.rapperEvent.add(GetRapperEvent(id: id));
    });

    test('Should emit Loading then Error when cache request fails', () async {
      when(mockGetConcreteRapper(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        Initial(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE)
      ];

      expectLater(rapperBloc.rapperState, emitsInOrder(expected));

      rapperBloc.rapperEvent.add(GetRapperEvent(id: id));
    });
  });

  // TODO: Implement tests for GetConcreteRapperList
}
