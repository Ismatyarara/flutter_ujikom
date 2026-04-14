import 'package:get/get.dart';
import 'package:ujikom_project/app/modules/toko/controllers/toko_controller.dart';

class TokoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TokoController>(() => TokoController());
  }
}
