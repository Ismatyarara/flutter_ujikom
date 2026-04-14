import 'package:get/get.dart';
import '../utils/api.dart';
import '../utils/api_helper.dart';

class JadwalService extends GetConnect {
  Future<Response> getJadwal() =>
      get(BaseUrl.jadwal, headers: ApiHelper.getAuthHeaders());
}
