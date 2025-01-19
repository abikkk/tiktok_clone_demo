import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_demo/core/constants/constant_variables.dart';
import 'package:tiktok_clone_demo/core/firebase/auth_service.dart';
import 'package:tiktok_clone_demo/core/utils/secure_storage_controller.dart';
import 'package:tiktok_clone_demo/core/utils/snackbar.dart';
import 'package:tiktok_clone_demo/feature/home/controllers/home_controller.dart';
import 'package:tiktok_clone_demo/feature/home/views/home_screen.dart';

class LoginController extends GetxController {
  RxBool processingLogin = false.obs;
  final AuthService authService = AuthService();
  HomeController homeController = Get.find<HomeController>();
  RxBool rememberLogin = false.obs;
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  // sign in using google
  signInWithGoogle() async {
    processingLogin(true);
    User? user = await authService.signIn();
    if (user != null) {
      homeController.userId(user);
      Get.offAll(() => HomeController());
    }
    processingLogin(false);
  }

  // sign in using email and password
  signInWithEmail({required String email, required String password}) async {
    processingLogin(true);
    User? user = await authService.signIn(
        withEmail: true, email: email, password: password);
    if (user != null) {
      homeController.userId(user);
      if (rememberLogin.value) {
        rememberUser(email: email, password: password);
      }
      snackBar().show(
          title: 'Success', message: 'Sign-in successful.', isSuccess: true);
      Get.offAll(() => HomeScreen());
    }
    processingLogin(false);
  }

  // remember current user session
  rememberUser({required String email, required String password}) async {
    debugPrint('## SAVING SESSION');
    SecureStorageController().save(id: savedEmail, text: email);
    SecureStorageController().save(id: savedPassword, text: password);
  }
}
