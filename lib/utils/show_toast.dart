import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackbar(String message,
    {Duration duration = (const Duration(seconds: 2))}) {
  Get.showSnackbar(
    GetSnackBar(
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
      duration: duration,
      backgroundColor: Colors.transparent,
    ),
  );
}
