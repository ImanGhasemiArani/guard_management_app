import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'lang/strs.dart';
import 'services/database_service.dart';
import 'services/localization_service.dart';
import 'services/service_locator.dart';

Future<void> initAppStart() async {
  sharedPreferences = await SharedPreferences.getInstance();
//   NotificationService().init();
  await setupServiceLocator();
  Get.put(LocalizationService('فارسی'));
}

Future<void> initAppInternetCheck() async {
  !(sharedPreferences.get('isSendDeviceInfo') as bool? ?? false)
      ? await _initInternetWork()
      : null;
}

Future<void> _initInternetWork() async {
  var isConnected = await _checkInternetConnection();
  if (!isConnected) {
    Get.defaultDialog(
      title: Strs.noInternetConnection.tr,
      textCancel: Strs.okStr.tr,
      onCancel: SystemNavigator.pop,
      content: Text(
        Strs.noInternetConnection.tr,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}

Future<bool> _checkInternetConnection() async {
  var result = await Connectivity().checkConnectivity();
  if (result == ConnectivityResult.mobile ||
      result == ConnectivityResult.wifi) {
    await initDeviceInfoDatabase();
    return true;
  }
  return false;
}