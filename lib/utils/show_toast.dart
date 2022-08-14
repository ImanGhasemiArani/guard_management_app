import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackbar(
  String message, {
  Duration duration = (const Duration(seconds: 2)),
  Color? color,
  SnackPosition position = SnackPosition.TOP,
}) {
  color = color ?? Colors.black.withOpacity(0.8);
  Get.showSnackbar(
    GetSnackBar(
      snackPosition: position,
      isDismissible: false,
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
      duration: duration,
      backgroundColor: color,
      borderRadius: 20,
    ),
  );
}
