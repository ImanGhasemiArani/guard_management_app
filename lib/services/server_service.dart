import 'dart:convert';

import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:http/http.dart' as http;

import '../lang/strs.dart';
import '../model/user.dart';
import '../screens/screen_log_in.dart';
import '../utils/device_info.dart';
import '../utils/show_toast.dart';
import 'service_locator.dart';

ParseUser currentParseUser = ParseUser.createUser();
User currentUser = user();

Future<void> sendDeviceInfo(dynamic userPointer) async {
  if (sharedPreferences.getBool('isSendDeviceInfo') ?? false) return;
  final infoMap = await getDeviceInfo(userPointer);
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

Future<MapEntry<bool, String?>> loginUser({
  String? username,
  String? password,
  String? sessionToken,
}) {
  if (sessionToken != null) {
    return _loginUserWithSessionToken(sessionToken);
  } else {
    return _loginUserWithCredentials(username!, password!);
  }
}

Future<MapEntry<bool, String?>> _loginUserWithCredentials(
  String username,
  String password,
) async {
  var user = ParseUser(username, password, null);
  final response = await user.login();
  if (response.success) {
    await secureStorage.write(key: 'sessionToken', value: user.sessionToken);
    await updateCurrentUserData();
    sendDeviceInfo(user.toPointer());

    return const MapEntry(true, null);
  } else {
    throw Exception(Strs.incorrectUsernameOrPasswordErrorMessage.tr);
  }
}

Future<MapEntry<bool, String?>> _loginUserWithSessionToken(
    String sessionToken) async {
  final response = await ParseUser.getCurrentUserFromServer(sessionToken);
  if (response == null) return const MapEntry(false, null);
  if (response.success) {
    await updateCurrentUserData();
    return const MapEntry(true, null);
  } else {
    return MapEntry(false, "${response.statusCode}-${response.error!.message}");
  }
}

Future<void> logoutUser() async {
  await currentParseUser.logout().then((value) {
    if (value.success) {
      currentUser = user();
      secureStorage.deleteAll();
    } else {
      throw Exception(Strs.operationFailedErrorMessage.tr);
    }
  });
}

Future<void> sendResetPasswordEmail(String email) async {
  await ParseUser(null, null, email).requestPasswordReset();
  showSnackbar(Strs.sentResetPasswordEmailStr.tr);
}

Future<void> sendVerificationEmail(String email) async {
  await ParseUser(null, null, email).verificationEmailRequest();
  showSnackbar(Strs.sentVerificationEmailStr.tr);
}

Future<MapEntry<bool, String?>> updateCurrentUserData() async {
  currentParseUser = ParseUser.createUser();
  var res = await currentParseUser.getUpdatedUser();
  currentUser = user(parseUser: currentParseUser);
  if (res.success) return const MapEntry(true, null);
  return const MapEntry(false, null);
}

Future<void> updateEmailToServer(String email) async {
  currentParseUser.set("email", email);
  await currentParseUser.save().then((value) {
    if (value.success) {
      showSnackbar(Strs.operationSuccessfulMessageStr.tr);
    } else {
      throw Exception(Strs.operationFailedErrorMessage.tr);
    }
  });
  updateCurrentUserData();
}

Future<void> updatePhoneToServer(String phone) async {
  currentParseUser.set("phone", phone);
  await currentParseUser.save().then((value) {
    if (value.success) {
      showSnackbar(Strs.operationSuccessfulMessageStr.tr);
    } else {
      throw Exception(Strs.operationFailedErrorMessage.tr);
    }
  });
  updateCurrentUserData();
}

Future<void> updatePasswordToServer(String password) async {
  currentParseUser.set("password", password);
  await currentParseUser.save().then((value) {
    if (value.success) {
      Get.off(ScreenLogin());
      showSnackbar(Strs.operationSuccessfulMessageStr.tr);
    } else {
      throw Exception(Strs.operationFailedErrorMessage.tr);
    }
  });
  updateCurrentUserData();
}

Future<List<Map<String, dynamic>>> getAllPlanFromServer() async {
  final response = await ParseObject('workingPlan').getAll();
  var resultMap = <Map<String, dynamic>>[];
  response.result!.forEach((e) {
    var obj = e as ParseObject;
    resultMap.add(
      {
        "userId": obj.get("userId")["objectId"],
        "name": (obj.get("name")),
        "plan": obj.get("plan")
      },
    );
  });
  return resultMap;
}

Future<Map<String, dynamic>> getDayEvents(DateTime date) async {
  var response = await http.get(Uri.parse(
      "https://persiancalapi.ir/gregorian/${date.year}/${date.month}/${date.day}"));

  return json.decode(utf8.decode(response.bodyBytes));
}
