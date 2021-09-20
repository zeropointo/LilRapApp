/// Exception used for network or endpoint failures of some kind.
class ServerException implements Exception {
  ServerException([this.message = "A server exception occured"]);
  final String message;
}

/// Exception used for cache failures of some kind.
class CacheException implements Exception {
  CacheException([this.message = "A cache exception occured"]);
  final String message;
}
