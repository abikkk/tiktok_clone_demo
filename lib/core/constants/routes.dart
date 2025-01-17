import 'package:get/get.dart';
import 'package:tiktok_clone_demo/feature/home/views/home_screen.dart';
import 'package:tiktok_clone_demo/feature/landing/view/landing_screen.dart';

final getPages = [
  GetPage(name: '/', page: () => HomeScreen()),
  GetPage(name: '/login', page: () => LandingScreen()),
  GetPage(
      name: '/signup',
      page: () => LandingScreen(
            isSignUp: true,
          )),
];
