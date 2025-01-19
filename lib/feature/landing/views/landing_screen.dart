import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_demo/feature/landing/controllers/landing_controller.dart';
import 'package:tiktok_clone_demo/feature/landing/controllers/login_controller.dart';
import 'package:tiktok_clone_demo/feature/landing/controllers/sign_up_controller.dart';
import 'package:tiktok_clone_demo/feature/landing/views/login_view.dart';
import 'package:tiktok_clone_demo/feature/landing/views/sign_up_view.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key, this.isSignUp = false});

  final bool isSignUp;

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LoginController loginController = Get.put(LoginController());
  SignUpController signUpController = Get.put(SignUpController());
  LandingController landingController = Get.find<LandingController>();

  @override
  void initState() {
    super.initState();
    landingController.checkRememberMe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        bottomNavigationBar: Obx(
          () => (landingController.loadingApp.value ||
                  loginController.processingLogin.value ||
                  signUpController.processingSignUp.value)
              ? SizedBox.shrink()
              : SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: Obx(
                    () => GestureDetector(
                      onTap: () {
                        // login
                        if (landingController.isLogin.value &&
                            loginController.loginFormKey.currentState!
                                .validate()) {
                          debugPrint('## LOGIN FORM VALIDATED');
                          loginController.signInWithEmail(
                              email:
                                  landingController.emailController.value.text,
                              password: landingController
                                  .passwordController.value.text);
                        }
                        // sign up
                        else if (!landingController.isLogin.value &&
                            signUpController.signUpFormKey.currentState!
                                .validate()) {
                          debugPrint('## SIGN UP FORM VALIDATED');
                          signUpController.signUp(
                              email:
                                  landingController.emailController.value.text,
                              password: landingController
                                  .passwordController.value.text);
                        } else {
                          debugPrint('## FORM(S) INVALID');
                        }
                      },
                      child: Container(
                        color: Colors.red,
                        child: Center(
                          child: Text(
                            (landingController.isLogin.value)
                                ? 'LOGIN'
                                : 'SIGN-UP',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Obx(() => (landingController.loadingApp.value)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Center(
                      child: PageView(
                        controller:
                            landingController.landingPageController.value,
                        pageSnapping: true,
                        onPageChanged: (i) {
                          if (i == 1) {
                            landingController.isLogin(false);
                          } else {
                            landingController.isLogin(true);
                          }
                        },
                        children: [
                          LoginView(),
                          SignUpView(),
                        ],
                      ),
                    )),
            ),
          ],
        ));
  }
}
