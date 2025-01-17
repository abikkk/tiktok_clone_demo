import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class LandingController extends GetxController {
  Rx<TextEditingController> emailController = TextEditingController().obs,
      passwordController = TextEditingController().obs,
      verifyPasswordController = TextEditingController().obs;
  RxBool loadingApp = true.obs, isLogin = true.obs;
  Rx<VideoPlayerController> logoController =
      VideoPlayerController.asset('logo.mp4').obs; //  logo video controller

  switchView({login = true}) {
    isLogin(login);
  }
}
