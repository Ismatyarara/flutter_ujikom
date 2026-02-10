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
      title: "Serenity",
      initialRoute: token != null ? Routes.HOME : Routes.LOGIN,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        primaryColor: const Color(0xFF1E3A8A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          secondary: const Color(0xFFFBBF24),
        ),
      ),
      home: token != null ? null : null,
    ),
  );
}
