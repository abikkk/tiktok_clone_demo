import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_demo/core/constants/routes.dart';
import 'package:tiktok_clone_demo/feature/home/controllers/home_controller.dart';
import 'package:tiktok_clone_demo/feature/landing/controller/landing_controller.dart';
import 'package:tiktok_clone_demo/feature/landing/view/landing_screen.dart';

void main() {
  Get.put(LandingController(),permanent: true);
  Get.put(HomeController(),permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KotKit Demo App',
      initialRoute: '/login',
      getPages: getPages,
      home: const LandingScreen(),
    );
  }
}
