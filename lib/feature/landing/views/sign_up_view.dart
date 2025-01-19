import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_demo/feature/landing/controllers/landing_controller.dart';
import 'package:tiktok_clone_demo/feature/landing/controllers/sign_up_controller.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  LandingController landingController = Get.find<LandingController>();
  SignUpController signUpController = Get.find<SignUpController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
          key: signUpController.signUpFormKey,
          child: Obx(
            () => (signUpController.processingSignUp.value)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: 20,
                    children: [
                      Center(
                        child: Text(
                          'Sign up',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      TextFormField(
                        controller: landingController.emailController.value,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email',
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !value.isEmail) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: landingController.passwordController.value,
                        obscureText: !landingController.showPassword.value,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            suffix: GestureDetector(
                              onTap: () => landingController.showPassword(
                                  !landingController.showPassword.value),
                              child: (landingController.showPassword.value)
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller:
                            landingController.verifyPasswordController.value,
                        obscureText: !landingController.showPassword.value,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            hintText: 'Verify password',
                            suffix: GestureDetector(
                              onTap: () => landingController.showPassword(
                                  !landingController.showPassword.value),
                              child: (landingController.showPassword.value)
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please verify your password';
                          } else if (value !=
                              landingController.passwordController.value.text) {
                            return "Passwords didn't match, please try again!";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(" Already have an account?"),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.navigate_before,
                                color: Colors.blue,
                              ),
                              GestureDetector(
                                onTap: () {
                                  landingController.switchView(login: true);
                                },
                                child: Text("Sign in here",
                                    style: TextStyle(color: Colors.blue)),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
          )),
    );
  }
}
