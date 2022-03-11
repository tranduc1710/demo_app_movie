import '../b_request.dart';

class BRequestApi {
  BRequest request = BRequest();

  void close() => request.closeRequest();
}
