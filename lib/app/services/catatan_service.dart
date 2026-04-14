import 'package:get/get.dart';
import '../utils/api.dart';
import '../utils/api_helper.dart';

class CatatanService extends GetConnect {
  Future<Response> getCatatan() =>
      get(BaseUrl.catatan, headers: ApiHelper.getAuthHeaders());
}
