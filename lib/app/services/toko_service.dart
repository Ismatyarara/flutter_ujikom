import 'package:get/get.dart';
import '../utils/api.dart';
import '../utils/api_helper.dart';

class TokoService extends GetConnect {
  Future<Response> getObat({String? search, int page = 1}) => get(
        '${BaseUrl.obat}?page=$page${search != null ? '&search=$search' : ''}',
        headers: ApiHelper.getAuthHeaders(),
      );

  Future<Response> getObatDetail(int id) => get(
        '${BaseUrl.obat}/$id',
        headers: ApiHelper.getAuthHeaders(),
      );

  Future<Response> beli(Map<String, dynamic> body) => post(
        BaseUrl.tokoBeli,
        body,
        headers: ApiHelper.getAuthHeaders(),
      );

  Future<Response> getRiwayat() => get(
        BaseUrl.tokoRiwayat,
        headers: ApiHelper.getAuthHeaders(),
      );

  Future<Response> getDetailTransaksi(int id) => get(
        '${BaseUrl.tokoRiwayat}/$id',
        headers: ApiHelper.getAuthHeaders(),
      );
}
