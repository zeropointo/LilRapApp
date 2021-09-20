import 'package:dartz/dartz.dart';
import 'package:lil_rap_app/features/artist_list/domain/entities/rapper.dart';
import 'package:lil_rap_app/features/artist_list/domain/repositories/rapper_repo.dart';
import 'package:lil_rap_app/features/artist_list/domain/usecases/get_concrete_rapper.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'get_concrete_rapper_test.mocks.dart';

/// Used to test the GetConcreteRapper usecase.

// Use the command 'flutter pub run build_runner build' to regenerate mocks
// library if adding or removing classes from the below annotation. Because of
// null-safety mocked classes should be generated this way if they take
// non-nullable params. The generated file is named
// get_concrete_rapper_test.mocks.dart

@GenerateMocks([RapperRepo])
void main() {
  late GetConcreteRapper usecase;
  late MockRapperRepo mockRapperRepo;

  setUp(() {
    mockRapperRepo = MockRapperRepo();
    usecase = GetConcreteRapper(mockRapperRepo);
  });

  final id = Uuid().v4();
  final rapper = Rapper(
      id: id,
      name: 'Lil Derivative',
      description:
          'The best linear approximation of a Rapper type person. Unlike his name, his work is anything but derivative.',
      image: 'https://avatars.githubusercontent.com/u/90428980?v=4');

  test('Should retrieve a Rapper object by its id', () async {
    // Arrange a mocked data repository response
    when(mockRapperRepo.getConcreteRapper(any))
        .thenAnswer((_) async => Right(rapper));

    // Execute the usecase that accesses the mocked data repository
    final result = await usecase(id); // Using callable class syntax

    // Check that the result was the fake rapper created above
    expect(result, Right(rapper));
    verify(mockRapperRepo.getConcreteRapper(id));
    verifyNoMoreInteractions(mockRapperRepo);
  });
}
