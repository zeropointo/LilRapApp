import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lil_rap_app/core/network/network_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'network_info_test.mocks.dart';

@GenerateMocks([Connectivity])
void main() {
  late NetworkInfoImpl networkInfo;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfo = NetworkInfoImpl(mockConnectivity);
  });

  group('isConnected', () {
    test('Should forward the call to Connectivity.checkConnectivity', () async {
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.mobile);

      final result = await networkInfo.isConnected;

      verify(mockConnectivity.checkConnectivity());
      expect(result, true);
    });
  });
}
