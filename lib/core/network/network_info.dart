import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

// Calling NetworkInfo().isConnected is really only a
// nickname for calling
// DataConnectionChecker().hasConnection.
class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  // TODO: implement isConnected
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
