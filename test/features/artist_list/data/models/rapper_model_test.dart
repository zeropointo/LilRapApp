import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:lil_rap_app/features/artist_list/data/models/rapper_model.dart';
import 'package:lil_rap_app/features/artist_list/domain/entities/rapper.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  final rapperModel = RapperModel(
      id: 'c3398b59-d654-4fd5-a595-fdf3cd13a1f0',
      name: 'Lil Derivative',
      description:
          'The best linear approximation of a Rapper type person. Unlike his name, his work is anything but derivative.',
      image: 'https://avatars.githubusercontent.com/u/90428980?v=4');

  test('Should be a subclass of Rapper entity', () async {
    expect(rapperModel, isA<Rapper>());
  });

  group('fromJson', () {
    test('Should return a model when fake JSON contains atleast one artist',
        () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('rappers.json'));

      final result = RapperModel.fromJson(jsonMap['artists'][0]);

      expect(result, equals(rapperModel));
    });
  });
}
