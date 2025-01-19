import 'package:flutter/material.dart';
import 'package:get/get.dart';

class snackBar {
  show(
      {bool isError = false,
      bool isSuccess = false,
      required String title,
      required String message}) {
    Get.snackbar(title, message,
        backgroundColor: isSuccess
            ? Colors.green
            : isError
                ? Colors.red
                : null,
        icon: isError ? Icon(Icons.error) : null);
  }
}
