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

class ServerService {
  static ParseUser currentParseUser = ParseUser.createUser();
  static User currentUser = user();

  static Future<void> sendDeviceInfo(dynamic userPointer) async {
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

  static Future<MapEntry<bool, String?>> loginUser({
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

  static Future<MapEntry<bool, String?>> _loginUserWithCredentials(
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

  static Future<MapEntry<bool, String?>> _loginUserWithSessionToken(
      String sessionToken) async {
    final response = await ParseUser.getCurrentUserFromServer(sessionToken);
    if (response == null) return const MapEntry(false, null);
    if (response.success) {
      await updateCurrentUserData();
      return const MapEntry(true, null);
    } else {
      return MapEntry(
          false, "${response.statusCode}-${response.error!.message}");
    }
  }

  static Future<void> logoutUser() async {
    await currentParseUser.logout().then((value) {
      if (value.success) {
        currentUser = user();
        secureStorage.deleteAll();
      } else {
        throw Exception(Strs.operationFailedErrorMessage.tr);
      }
    });
  }

  static Future<void> sendResetPasswordEmail(String email) async {
    await ParseUser(null, null, email).requestPasswordReset();
    showSnackbar(Strs.sentResetPasswordEmailStr.tr);
  }

  static Future<void> sendVerificationEmail(String email) async {
    await ParseUser(null, null, email).verificationEmailRequest();
    showSnackbar(Strs.sentVerificationEmailStr.tr);
  }

  static Future<MapEntry<bool, String?>> updateCurrentUserData() async {
    currentParseUser = ParseUser.createUser();
    var res = await currentParseUser.getUpdatedUser();
    currentUser = user(parseUser: currentParseUser);
    if (res.success) return const MapEntry(true, null);
    return const MapEntry(false, null);
  }

  static Future<void> updateEmailToServer(String email) async {
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

  static Future<void> updatePhoneToServer(String phone) async {
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

  static Future<void> updatePasswordToServer(String password) async {
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

  static Future<List<Map<String, dynamic>>> getAllPlanFromServer() async {
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

  static Future<Map<String, dynamic>> getDayEvents(DateTime date) async {
    var response = await http.get(Uri.parse(
        "https://persiancalapi.ir/gregorian/${date.year}/${date.month}/${date.day}"));

    return json.decode(utf8.decode(response.bodyBytes));
  }

  static Future<Map<String, dynamic>> getSpecificUserPlan({
    required String username,
    isFilterMPlans = false,
  }) async {
    // response = await ParseObject('Plan').getAll();
    late final ParseResponse response;
    if (isFilterMPlans) {
      final func = ParseCloudFunction("specificUserPlanWithFilterM");
      response = await func.execute(parameters: {"username": username});
    } else {
      final func = ParseCloudFunction("specificUserPlan");
      response = await func.execute(parameters: {"username": username});
    }
    if (response.success) {
      final result = (response.result as Map<String, dynamic>);
      return result;
    } else {
      throw Exception(Strs.failedToLoadDataFromServerErrorMessage.tr);
    }
  }

  static Future<String?> getNameByNationalId(String nationalId) async {
    final func = ParseCloudFunction("getNameByUsername");
    final response = await func.execute(parameters: {"username": nationalId});
    if (response.success) {
      return response.result as String?;
    } else {
      throw Exception(Strs.failedToLoadDataFromServerErrorMessage.tr);
    }
  }

  static Future<Map<String, String>> getUserMapUsernameToName({
    isFilterDPlans = false,
  }) async {
    late final ParseResponse response;
    if (isFilterDPlans) {
      final func = ParseCloudFunction("getUsersMapUsernameToNameWithFilterM");
      response = await func.execute();
    } else {
      final func = ParseCloudFunction("getUsersMapUsernameToName");
      response = await func.execute();
    }
    if (response.success) {
      final resultList = response.result as Map<String, dynamic>;
      return resultList.map((key, value) => MapEntry(key, value as String));
    } else {
      throw Exception(Strs.failedToLoadDataFromServerErrorMessage.tr);
    }
  }
}
