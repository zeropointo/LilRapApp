import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:lil_rap_app/core/error/exceptions.dart';
import 'package:lil_rap_app/features/artist_list/data/models/rapper_model.dart';
import 'package:lil_rap_app/features/artist_list/data/sources/rapper_remote_source.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'rapper_remote_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late RapperRemoteSourceImpl dataSource;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    dataSource = RapperRemoteSourceImpl(client: mockClient);
  });

  group('getConcreteRapper', () {
    final Map<String, dynamic> jsonMap = json.decode(fixture('rappers.json'));

    final rapperModel = [RapperModel.fromJson(jsonMap['artists'][0])];

    test('Should do an HTTP GET and retrieve rapper list JSON from the server',
        () async {
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('rappers.json'), 200));

      dataSource.getConcreteRapperList();

      verify(mockClient.get(
          Uri.parse(
              'https://github.com/zeropointo/LilRapApp/blob/main/rapper_data/rappers.json?raw=true'),
          headers: {'Content-Type': 'application/json'}));
    });

    test('Should return Rapper when the HTTP request is successful (200)',
        () async {
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('rappers.json'), 200));

      final result = await dataSource.getConcreteRapperList();

      expect(result, equals(rapperModel));
    });

    test(
        'Should throw a ServerException when the HTTP request is not successful',
        () async {
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Server request failed', 404));

      final call = dataSource.getConcreteRapperList;

      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
