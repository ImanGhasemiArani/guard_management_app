import 'package:get/get.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

import '../lang/strs.dart';
import '../utils/device_info.dart';
import '../utils/show_toast.dart';
import 'service_locator.dart';

ParseUser currentUser = ParseUser.createUser();

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
    await secureStorage.write(key: 'username', value: username);
    await secureStorage.write(key: 'password', value: password);
    await updateCurrentUserData();
    return const MapEntry(true, null);
  } else {
    return MapEntry(false, "${response.statusCode}-${response.error!.message}");
  }
}

Future<void> sendResetPasswordEmail(String email) async {
  await ParseUser(null, null, email).requestPasswordReset();
  showSnackbar(Strs.sentResetPasswordEmailStr.tr);
}

Future<void> updateCurrentUserData() async {
  currentUser = ParseUser.createUser();
  await currentUser.getUpdatedUser();
}

Future<void> updateEmail(String email) async {
  currentUser.set("email", email);
  await currentUser.save();
  updateCurrentUserData();
}

Future<void> updatePassword(String password) async {
    currentUser.set("password", password);
    await currentUser.save();
    updateCurrentUserData();
}
