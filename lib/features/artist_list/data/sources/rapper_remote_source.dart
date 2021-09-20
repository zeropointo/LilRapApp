import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../models/rapper_model.dart';

// Abstraction representing a remote network data source.
abstract class RapperRemoteSource {
  /// Retrieves rapper list from JSON file
  ///
  /// Throws a ServerException for all errors.
  Future<List<RapperModel>> getConcreteRapperList();
}

/// A remote data source accessing data from aloompa's AWS server.
class RapperRemoteSourceImpl implements RapperRemoteSource {
  RapperRemoteSourceImpl({required this.client});

  final http.Client client;

  @override
  Future<List<RapperModel>> getConcreteRapperList() async {
    try {
      final response = await client.get(
          Uri.parse(
              'https://github.com/zeropointo/LilRapApp/blob/main/rapper_data/rappers.json?raw=true'),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        List<RapperModel> rapperList = [];
        for (var artist in jsonMap['artists']) {
          rapperList.add(RapperModel.fromJson(artist));
        }
        return rapperList;
      } else {
        throw ServerException('Server responded with failure code ' +
            response.statusCode.toString());
      }
    } on Exception catch (e) {
      throw ServerException(e.toString());
    }
  }
}
