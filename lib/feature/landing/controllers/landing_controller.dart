import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_demo/core/constants/constant_variables.dart';
import 'package:tiktok_clone_demo/core/utils/secure_storage_controller.dart';
import 'package:tiktok_clone_demo/feature/landing/controllers/login_controller.dart';

class LandingController extends GetxController {
  Rx<TextEditingController> emailController = TextEditingController().obs,
      passwordController = TextEditingController().obs,
      verifyPasswordController = TextEditingController().obs;
  RxBool loadingApp = true.obs, isLogin = true.obs, showPassword = false.obs;
  Rx<PageController> landingPageController = PageController(initialPage: 0).obs;

  // switch landing page sections
  switchView({login = true}) {
    if (!login) {
      landingPageController.value.nextPage(
          duration: Duration(milliseconds: 444), curve: Curves.easeInOut);
    } else {
      landingPageController.value.previousPage(
          duration: Duration(milliseconds: 444), curve: Curves.easeInOut);
    }
    isLogin(login);
  }

  checkRememberMe() async {
    loadingApp(true);
    debugPrint('## CHECKING REMEMBER ME SESSION');
    String? email = await SecureStorageController().read(id: savedEmail);
    if (email != null && email.trim().isNotEmpty) {
      String? password =
          await SecureStorageController().read(id: savedPassword);
      Get.find<LoginController>()
          .signInWithEmail(email: email, password: password!);
    }
    loadingApp(false);
  }
}
