import 'package:device_info_plus/device_info_plus.dart';

Future<Map<String, dynamic>> getDeviceInfo() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  late final Map<String, String> infoMap;
  try {
    final deviceInfo = await deviceInfoPlugin.androidInfo;
    infoMap = {
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
