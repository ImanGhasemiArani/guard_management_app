import 'package:device_info_plus/device_info_plus.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'service_locator.dart';

Future<void> initDeviceInfoDatabase() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  late final infoMap;
  try {
    final deviceInfo = await deviceInfoPlugin.androidInfo;
    infoMap = {
      'model':
          "${deviceInfo.brand ?? "null"} /w ${deviceInfo.device ?? "null"} //w ${deviceInfo.model ?? "null"}",
      'version':
          "${deviceInfo.version.release ?? "null"} ${deviceInfo.display ?? "null"}",
      'sdk': deviceInfo.version.sdkInt ?? 0,
      'web': "not supported",
    };
  } catch (e) {
    final webDeviceInfo = await deviceInfoPlugin.webBrowserInfo;
    infoMap = {
      'model': "not supported",
      'version': "not supported",
      'sdk': "not supported",
      'web':
          "${webDeviceInfo.browserName.name} /w ${webDeviceInfo.appVersion} //w ${webDeviceInfo.platform}",
    };
  }

  print(infoMap);

//   await Parse().initialize(
//     'LFfqRZZm7stkLIDHdnxded6EIlJsUQCeUjYyCSIi',
//     'https://parseapi.back4app.com',
//     clientKey: 'lV11wBilBDxOd4rF7NOpnmWXciL8W55VoxTNB2y0',
//     autoSendSessionId: true,
//   );
//   var dataRef = ParseObject('Devices');
//   infoMap.forEach((key, value) => dataRef.set(key, value));
//   dataRef
//       .save()
//       .then((value) => sharedPreferences.setBool('isSendDeviceInfo', true));
}
