import 'package:get/get.dart';
import 'package:ujikom_project/app/middlewares/auth_middlewares.dart';
import 'package:ujikom_project/app/modules/auth/bindings/auth_binding.dart';
import 'package:ujikom_project/app/modules/auth/views/auth_view.dart';
import 'package:ujikom_project/app/modules/auth/views/login_view.dart';
import 'package:ujikom_project/app/modules/auth/views/register_view.dart';
import 'package:ujikom_project/app/modules/home/bindings/home_binding.dart';
import 'package:ujikom_project/app/modules/home/views/home_view.dart';
import 'package:ujikom_project/app/modules/toko/view/obat_list_view.dart';
import 'package:ujikom_project/app/modules/toko/bindings/toko_binding.dart';


part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView (),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.TOKO,
      page: () => const ObatListView(),
      binding: TokoBinding(),
    ),
  ];
}
