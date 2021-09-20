import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstraction representing a network connection checker.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Used to check if a wifi or mobile network is available on the device.
class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(this.connectionChecker);

  final Connectivity connectionChecker;

  @override
  Future<bool> get isConnected async {
    var connectivityResult = await connectionChecker.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
