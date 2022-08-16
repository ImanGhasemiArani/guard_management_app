import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackbar(
  String message, {
  Duration duration = (const Duration(seconds: 2)),
  Color? color,
  SnackPosition position = SnackPosition.TOP,
  MessageType messageType = MessageType.warning,
}) {
  Color bgColor;
  switch (messageType) {
    case MessageType.success:
      bgColor = Colors.green;
      break;
    case MessageType.error:
      bgColor = Colors.red;
      break;
    case MessageType.warning:
      bgColor = Colors.amber;
      break;
  }
  if (color != null) {
    bgColor = color;
  }
  Get.showSnackbar(
    GetSnackBar(
      snackStyle: SnackStyle.FLOATING,
      snackPosition: position,
      isDismissible: false,
      messageText: Text(
        message,
        style: const TextStyle(),
        textAlign: TextAlign.center,
      ),
      duration: duration,
      borderColor: bgColor,
      backgroundColor: bgColor.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(horizontal: 30),
      barBlur: 10,
      borderRadius: 10,
    ),
  );
}

enum MessageType {
  success,
  error,
  warning,
}
