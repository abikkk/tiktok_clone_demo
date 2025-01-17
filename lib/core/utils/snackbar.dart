import 'package:flutter/material.dart';
import 'package:get/get.dart';

class snackbar {
  show({bool isError = false, required String title, required String message}) {
    Get.snackbar(title, message,
        backgroundColor: isError ? Colors.red : null,
        icon: isError ? Icon(Icons.error) : null);
  }
}
