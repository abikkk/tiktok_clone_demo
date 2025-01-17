import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_demo/feature/landing/controller/landing_controller.dart';
import 'package:tiktok_clone_demo/feature/landing/view/login_view.dart';
import 'package:tiktok_clone_demo/feature/landing/view/sign_up_view.dart';
import 'package:video_player/video_player.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key, this.isSignUp = false});

  final bool isSignUp;

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LandingController landingController = Get.find<LandingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: 200,
          width: double.maxFinite,
          child: Obx(() => VideoPlayer(
                landingController.logoController.value,
              )),
        ),
        Expanded(
          child: Obx(() => PageView(
                pageSnapping: true,
                children: [LoginView(), SignUpView()],
              )),
        )
      ],
    ));
  }
}
