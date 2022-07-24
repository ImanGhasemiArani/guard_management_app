import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../lang/strs.dart';
import 'database_service.dart';

late SharedPreferences sharedPreferences;
bool isShowDialog = false;

Future<void> setupServiceLocator() async {
  _setupConnectionListener();
  await _checkConnection();
  _initParseServer();

  await sendDeviceInfoToServer();
}

Future<void> _initParseServer() async {
  await Parse().initialize(
    'K3yL8XzVdSzmalKXwungWmewdA7owL2M9QbHn9Sb',
    'https://parseapi.back4app.com',
    clientKey: 'EPXyTqyFnU3lgaIFW27elMWZgVAp57C7kQUFOWHf',
    autoSendSessionId: true,
  );
}

_setupConnectionListener() {
  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      _showConnectionError();
    }
  });
}

Future<void> _checkConnection() async {
  final isConnectedToInternet = await _checkInternetConnection();
  if (!isConnectedToInternet) {
    _showConnectionError();
  }
}

Future<bool> _checkInternetConnection() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi;
}

Future<void> _showConnectionError() async {
  if (isShowDialog) return;
  isShowDialog = true;
  showCupertinoDialog(
    context: Get.context!,
    builder: (BuildContext buildContext) {
      return CupertinoAlertDialog(
        title: Text(
          Strs.noInternetConnectionStr.tr,
          style: TextStyle(
              fontFamily: Get.theme.textTheme.button!.fontFamily, fontSize: 16),
        ),
        content: Text(
          Strs.noInternetConnectionMessageStr,
          style: TextStyle(
              fontFamily: Get.theme.textTheme.button!.fontFamily, fontSize: 14),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text(Strs.cancelStr.tr),
            onPressed: () {
              isShowDialog = false;
              SystemNavigator.pop();
            },
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(Strs.tryAgainStr.tr),
            onPressed: () {
              isShowDialog = false;
              Get.back();
              _checkConnection();
            },
          ),
        ],
      );
    },
  );
}
