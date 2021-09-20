import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:lil_rap_app/core/error/exceptions.dart';
import 'package:lil_rap_app/features/artist_list/data/models/rapper_model.dart';
import 'package:lil_rap_app/features/artist_list/data/sources/rapper_local_source.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'rapper_local_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late RapperLocalSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource =
        RapperLocalSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getLastRapperList', () {
    final Map<String, dynamic> jsonMap =
        json.decode(fixture('rappers_cached.json'));

    final rapperModel = [RapperModel.fromJson(jsonMap['artists'][0])];

    test('Should return a List<RapperModel> from server when data exists',
        () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('rappers_cached.json'));

      final result = await dataSource.getLastRapperList();

      verify(mockSharedPreferences.getString(CACHED_RAPPER_LIST));
      expect(result, equals(rapperModel));
    });

    test('Should throw a CacheException when there is no cached rapper data',
        () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      final call = dataSource.getLastRapperList;

      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });

    test('Should call SharedPreferences to cache rapper list', () async {
      when(mockSharedPreferences.setString(CACHED_RAPPER_LIST, any))
          .thenAnswer((_) async => Future.value(true));

      dataSource.cacheRapperList(rapperModel);

      final expected = json.encode({'artists': rapperModel});

      verify(mockSharedPreferences.setString(CACHED_RAPPER_LIST, expected));
    });
  });
}
