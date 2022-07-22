import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'lang/strs.dart';
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
    await _initDatabase();
    return true;
  }
  return false;
}

Future<void> _initDatabase() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceInfo = await deviceInfoPlugin.androidInfo;
  final webDeviceInfo = await deviceInfoPlugin.webBrowserInfo;
  final infoMap = {
    'model':
        "${deviceInfo.brand ?? "null"}_${deviceInfo.device ?? "null"}__${deviceInfo.model ?? "null"}",
    'version':
        "${deviceInfo.version.release ?? "null"} ${deviceInfo.display ?? "null"}",
    'sdk': deviceInfo.version.sdkInt ?? 0,
    'web': "${webDeviceInfo.browserName}_${webDeviceInfo.appVersion}__${webDeviceInfo.platform}",
  };
//   await Parse().initialize(
//     'LFfqRZZm7stkLIDHdnxded6EIlJsUQCeUjYyCSIi',
//     'https://parseapi.back4app.com',
//     clientKey: 'lV11wBilBDxOd4rF7NOpnmWXciL8W55VoxTNB2y0',
//     autoSendSessionId: true,
//   );
  var dataRef = ParseObject('Devices');
  infoMap.forEach((key, value) => dataRef.set(key, value));
  dataRef
      .save()
      .then((value) => sharedPreferences.setBool('isSendDeviceInfo', true));
}
