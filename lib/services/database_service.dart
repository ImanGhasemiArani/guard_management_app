import 'package:get/get.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

import '../lang/strs.dart';
import '../utils/device_info.dart';
import '../utils/show_toast.dart';
import 'service_locator.dart';

Future<void> sendDeviceInfoToServer() async {
  if (sharedPreferences.getBool('isSendDeviceInfo') ?? false) return;
  final infoMap = await getDeviceInfo();
  var objRef = ParseObject('Devices');
  infoMap.forEach((key, value) => objRef.set(key, value));
  final response = await objRef.save();
  if (response.success) {
    sharedPreferences.setBool('isSendDeviceInfo', true);
    showSnackbar(Strs.deviceInfoSuccessfullySentStr.tr);
  } else {
    showSnackbar(Strs.deviceInfoFailedToSendStr.tr);
  }
}

Future<MapEntry<bool, String?>> logInUser(
    String username, String password, String email) async {
  var user = ParseUser(username, password, email);
  final response = await user.login();
  if (response.success) {
    if (email.isNotEmpty) {
      user.set("email", email);
      await user.save();
    }
    return const MapEntry(true, null);
  } else {
    return MapEntry(false, "${response.statusCode}-${response.error!.message}");
  }
}

Future<void> sendResetPasswordEmail(String email) async {
  await ParseUser(null, null, email).requestPasswordReset();
  showSnackbar(Strs.sentResetPasswordEmailStr.tr);
}
