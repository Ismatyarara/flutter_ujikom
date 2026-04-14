import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final box = GetStorage();
  final token = box.read('token');

  runApp(
    GetMaterialApp(
      title: 'HealTack',
      initialRoute: token != null ? Routes.HOME : Routes.LOGIN,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: const Color(0xFF1A56DB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A56DB),
          primary: const Color(0xFF1A56DB),
          secondary: const Color(0xFF74B4FF),
          surface: const Color(0xFFF4F7FF),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7FF),
      ),
    ),
  );
}
