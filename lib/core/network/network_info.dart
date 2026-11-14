import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  
  NetworkInfoImpl(this.connectivity);
  
  @override
  Future<bool> get isConnected async {
    try {
      final ConnectivityResult result = await connectivity.checkConnectivity();
      
      if (result == ConnectivityResult.none) {
        return false;
      }
      // Additional check to ensure internet access
      final internetResult = await InternetAddress.lookup('google.com');
      return internetResult.isNotEmpty && internetResult[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}

