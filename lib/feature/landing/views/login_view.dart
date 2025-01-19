import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_demo/feature/landing/controllers/landing_controller.dart';
import 'package:tiktok_clone_demo/feature/landing/controllers/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LandingController landingController = Get.find<LandingController>();
  LoginController loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
          key: loginController.loginFormKey,
          child: Obx(
            () => (loginController.processingLogin.value)
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
                          'Login',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      TextFormField(
                        controller: landingController.emailController.value,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
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
                      Obx(
                        () => TextFormField(
                          controller:
                              landingController.passwordController.value,
                          obscureText: !landingController.showPassword.value,
                          textInputAction: TextInputAction.done,
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
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Checkbox(
                              value: loginController.rememberLogin.value,
                              activeColor: Colors.red,
                              onChanged: (v) {
                                loginController.rememberLogin(v);
                              }),
                          Text("Remember me.")
                        ],
                      ),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.end,
                      //   children: [
                      //     Text(
                      //       'Or,',
                      //       textAlign: TextAlign.end,
                      //       style: TextStyle(fontSize: 18),
                      //     ),
                      //     GestureDetector(
                      //       onTap: () {
                      //         // login using google
                      //         loginController.signInWithGoogle();
                      //       },
                      //       child: Text(
                      //         'Sign in with Google instead.',
                      //         textAlign: TextAlign.end,
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      SizedBox(
                        height: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Don't have an account yet? "),
                          GestureDetector(
                            onTap: () {
                              landingController.switchView(login: false);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("Create one here",
                                    style: TextStyle(color: Colors.blue)),
                                Icon(
                                  Icons.navigate_next,
                                  color: Colors.blue,
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
          )),
    );
  }
}
