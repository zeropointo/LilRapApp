import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/rapper_model.dart';

/// Abstraction representing a local data cache.
abstract class RapperLocalSource {
  /// Retrieves the last rapper list retrieved from network source.
  ///
  /// Throws a CacheException if no cached data is found.
  Future<List<RapperModel>> getLastRapperList();

  /// Used to cache a rapper list when retrieved from the network.
  Future<void> cacheRapperList(List<RapperModel> rapperList);
}

const CACHED_RAPPER_LIST = 'CACHED_RAPPER_LIST';

/// A local data cache using SharedPreferences.
class RapperLocalSourceImpl implements RapperLocalSource {
  RapperLocalSourceImpl({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<List<RapperModel>> getLastRapperList() {
    final jsonString = sharedPreferences.getString(CACHED_RAPPER_LIST);

    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      List<RapperModel> rapperList = [];
      for (var artist in jsonMap['artists']) {
        rapperList.add(RapperModel.fromJson(artist));
      }
      return Future.value(rapperList);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheRapperList(List<RapperModel> rapperList) {
    List<Map<String, dynamic>> artists = [];

    for (RapperModel rapperModel in rapperList) {
      artists.add(rapperModel.toJson());
    }

    return sharedPreferences.setString(
        CACHED_RAPPER_LIST, json.encode({'artists': artists}));
  }
}
