import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../lang/strs.dart';
import 'server_service.dart';

late SharedPreferences sharedPreferences;
late FlutterSecureStorage secureStorage;
bool isShowDialog = false;

Future<MapEntry<bool, String?>> setupServices() async {
  await _setupServiceLocator();
  final response = await _hasLoginUser();
  if (response.key) {
    await _listenToNotifications();
  }
  return response;
}

Future<void> _setupServiceLocator() async {
  _setupConnectionListener();
  await _checkInternetConnection();
  await _initParseServer();
}

Future<void> _initParseServer() async {
  //Sekeh Database
  await Parse().initialize(
    '3bwJDJEU7Ox8dnWZ3qYwzaVaOYw2rin7BVcOlvei',
    'https://parseapi.back4app.com',
    clientKey: 'JWSPNTBOgS2aKn7jbU8d0gSo3NQJIdN5MicrzuoF',
  );
  //GuardManagement Database
//   await Parse().initialize(
//     'K3yL8XzVdSzmalKXwungWmewdA7owL2M9QbHn9Sb',
//     'https://parseapi.back4app.com',
//     clientKey: 'EPXyTqyFnU3lgaIFW27elMWZgVAp57C7kQUFOWHf',
//   );
}

void _setupConnectionListener() {
  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      _showConnectionError();
    } else {
      //   isShowDialog ? Get.back() : null;
    }
  });
}

Future<void> _checkInternetConnection() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  final isConnectedToInternet =
      connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi;
  if (!isConnectedToInternet) {
    _showConnectionError();
  }
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
              _checkInternetConnection();
            },
          ),
        ],
      );
    },
  );
}

Future<MapEntry<bool, String?>> _hasLoginUser() async {
  var sessionToken = await secureStorage.read(key: 'sessionToken');
  if (sessionToken == null) return const MapEntry(false, null);
  return await ServerService.loginUser(sessionToken: sessionToken);
}

Future<void> _listenToNotifications() async {
//   final requests = await ServerService.getExRequestsFromServer(
//       username: ServerService.currentUser.username!);
//   final reqs = requests.map((e) => ExchangeRequest.fromParse(e)).toList();
}

Future<void> setupMessagingService() async {
}
