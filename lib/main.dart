import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_demo/core/constants/routes.dart';
import 'package:tiktok_clone_demo/feature/home/controllers/home_controller.dart';
import 'package:tiktok_clone_demo/feature/landing/controllers/landing_controller.dart';
import 'package:tiktok_clone_demo/feature/landing/views/landing_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Get.put(LandingController(), permanent: true);
  Get.put(HomeController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KotKit Demo App',
      initialRoute: '/',
      getPages: getPages,
      home: const LandingScreen(),
    );
  }
}
