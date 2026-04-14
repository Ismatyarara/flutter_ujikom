import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ujikom_project/app/routes/app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final box = GetStorage();
    final token = box.read('token');

    if (token == null || token.toString().isEmpty) {
      return const RouteSettings(name: Routes.LOGIN);
    }

    return null;
  }
}
