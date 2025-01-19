import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_demo/core/firebase/auth_service.dart';
import 'package:tiktok_clone_demo/core/utils/snackbar.dart';
import 'package:tiktok_clone_demo/feature/home/controllers/home_controller.dart';
import 'package:tiktok_clone_demo/feature/landing/controllers/login_controller.dart';

class SignUpController extends GetxController {
  RxBool processingSignUp = false.obs;
  final AuthService authService = AuthService();
  HomeController homeController = Get.find<HomeController>();
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  signUp({required String email, required String password}) async {
    processingSignUp(true);
    User? user = await authService.signUp(email: email, password: password);
    processingSignUp(false);
    if (user != null) {
      snackBar().show(
          title: 'Success',
          message: 'Account setup successful.',
          isSuccess: true);
      homeController.userId(user);
      Get.find<LoginController>()
          .signInWithEmail(email: email, password: password);
    } else {
      snackBar()
          .show(title: 'Error', message: 'Could not sign-up.', isError: true);
    }
  }
}
