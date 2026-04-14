import 'package:get/get.dart';

import '../utils/api.dart';

class MobileHomeService extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 12);
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers.addAll(BaseUrl.defaultHeaders);
      return request;
    });
    super.onInit();
  }

  Future<Response> getHome() {
    return get(BaseUrl.mobileHome);
  }
}
