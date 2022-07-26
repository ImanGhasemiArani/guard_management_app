import 'package:device_info_plus/device_info_plus.dart';

Future<Map<String, dynamic>> getDeviceInfo(dynamic userPointer) async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  late final Map<String, dynamic> infoMap;
  try {
    final deviceInfo = await deviceInfoPlugin.androidInfo;
    infoMap = {
      'userId': userPointer as Map<String, dynamic>,
      'deviceId': deviceInfo.id ?? "null",
      'model':
          "${deviceInfo.manufacturer ?? "null"} ${deviceInfo.brand ?? "null"} /w ${deviceInfo.device ?? "null"} //w ${deviceInfo.model ?? "null"}",
      'version':
          "${deviceInfo.version.release ?? "null"} ${deviceInfo.display ?? "null"}",
      'sdk': "${deviceInfo.version.sdkInt ?? 0}",
      'web': "not supported",
    };
  } catch (e) {
    final webDeviceInfo = await deviceInfoPlugin.webBrowserInfo;
    infoMap = {
      'userId': userPointer as Map<String, dynamic>,
      'deviceId': "not supported",
      'model': "not supported",
      'version': "not supported",
      'sdk': "not supported",
      'web':
          "${webDeviceInfo.browserName.name} /w ${webDeviceInfo.appVersion} //w ${webDeviceInfo.platform}",
    };
  }
  return infoMap;
}
