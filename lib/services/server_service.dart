import 'dart:convert';

import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:http/http.dart' as http;

import '../lang/strs.dart';
import '../model/exchange_request.dart';
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
      showSnackbar(
        Strs.deviceInfoSuccessfullySentStr.tr,
        messageType: MessageType.success,
      );
    } else {
      showSnackbar(
        Strs.deviceInfoFailedToSendStr.tr,
        messageType: MessageType.error,
      );
    }
  }

  static Future<MapEntry<bool, String?>> loginUser({
    String? username,
    String? password,
    String? sessionToken,
  }) async {
    final MapEntry<bool, String?> response;
    if (sessionToken != null) {
      response = await _loginUserWithSessionToken(sessionToken);
    } else {
      response = await _loginUserWithCredentials(username!, password!);
    }
    if (response.key) {
      setupAfterLogging();
    }
    return response;
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
    showSnackbar(
      Strs.sentResetPasswordEmailStr.tr,
      messageType: MessageType.warning,
    );
  }

  static Future<void> sendVerificationEmail(String email) async {
    await ParseUser(null, null, email).verificationEmailRequest();
    showSnackbar(
      Strs.sentVerificationEmailStr.tr,
      messageType: MessageType.warning,
    );
  }

  static Future<MapEntry<bool, String?>> updateCurrentUserData() async {
    currentParseUser = ParseUser.createUser();
    var res = await currentParseUser.getUpdatedUser();
    currentUser = user(parseUser: currentParseUser);
    try {
      currentUser.teamData =
          await getSpecificUserTeamInfo(username: currentUser.username!);
    } catch (e) {
      return const MapEntry(false, null);
    }
    if (res.success) return const MapEntry(true, null);
    return const MapEntry(false, null);
  }

  static Future<void> updateProfileImgToServer(String profileImgStr) async {
    currentParseUser.set("profileImg", profileImgStr);
    await currentParseUser.save().then((value) {
      if (value.success) {
        showSnackbar(
          Strs.operationSuccessfulMessageStr.tr,
          messageType: MessageType.success,
        );
      } else {
        showSnackbar(
          Strs.operationFailedErrorMessage.tr,
          messageType: MessageType.error,
        );
      }
    });
    updateCurrentUserData();
  }

  static Future<void> updateEmailToServer(String email) async {
    currentParseUser.set("email", email);
    await currentParseUser.save().then((value) {
      if (value.success) {
        showSnackbar(
          Strs.operationSuccessfulMessageStr.tr,
          messageType: MessageType.success,
        );
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
        showSnackbar(
          Strs.operationSuccessfulMessageStr.tr,
          messageType: MessageType.success,
        );
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
        showSnackbar(
          Strs.operationSuccessfulMessageStr.tr,
          messageType: MessageType.success,
        );
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

  static Future<List<Map<String, dynamic>>> getAllUserSchedule(
      {bool isOnlyGuard = false,
      bool isFilterDate = false,
      String? afterDate}) async {
    final func = ParseCloudFunction("allUserSchedule");
    final response = await func.execute(parameters: {
      "isOnlyGuard": isOnlyGuard,
      "isFilterDate": isFilterDate,
      "afterDate": afterDate
    });
    if (response.success) {
      final result = response.result as List<dynamic>;
      return result.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception(Strs.failedToLoadDataFromServerErrorMessage.tr);
    }
  }

  static Future<Map<String, dynamic>> getSpecificUserSchedule(
      {required String username,
      bool isOnlyGuard = false,
      bool isFilterDate = false,
      String? afterDate}) async {
    final func = ParseCloudFunction("specificUserSchedule");
    final response = await func.execute(parameters: {
      "username": username,
      "isOnlyGuard": isOnlyGuard,
      "isFilterDate": isFilterDate,
      "afterDate": afterDate
    });
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

  static Future<Map<String, dynamic>> getUsersAvailableForExchange() async {
    final func = ParseCloudFunction("getUsersAvailableForExchange");
    final response =
        await func.execute(parameters: {"username": currentUser.username});
    if (response.success) {
      final resultList = response.result as Map<String, dynamic>;
      return resultList;
    } else {
      throw Exception(Strs.failedToLoadDataFromServerErrorMessage.tr);
    }
  }

  static Future<Map<String, String>> getUsersMapUsernameToName({
    bool isOnlyGuard = false,
  }) async {
    final func = ParseCloudFunction("getUsersMapUsernameToName");
    final response =
        await func.execute(parameters: {"isOnlyGuard": isOnlyGuard});
    if (response.success) {
      final resultList = response.result as Map<String, dynamic>;
      return resultList.map((key, value) => MapEntry(key, value as String));
    } else {
      throw Exception(Strs.failedToLoadDataFromServerErrorMessage.tr);
    }
  }

  static Future<Map<String, dynamic>> getSpecificUserTeamInfo(
      {required String username}) async {
    final func = ParseCloudFunction("getSpecificUserTeamInfo");
    final response = await func.execute(parameters: {"username": username});
    if (response.success) {
      final resultList = response.result as Map<String, dynamic>;
      return resultList;
    } else {
      throw Exception(Strs.failedToLoadDataFromServerErrorMessage.tr);
    }
  }

  static Future<void> createExchangeRequest({
    required String username,
    required ExchangeRequest request,
  }) async {
    final func = ParseCloudFunction("createExchangeRequest");
    final response = await func.execute(parameters: {
      'request': request.parseMap(),
    });
    if (response.success) {
      try {
        if (response.result as bool) {
          showSnackbar(Strs.operationSuccessfulMessageStr.tr,
              messageType: MessageType.success);
        } else {
          showSnackbar(Strs.failedToRegisterRequestErrorMessage.tr,
              messageType: MessageType.error);
        }
      } catch (e) {
        showSnackbar(Strs.duplicateRequestErrorMessage.tr,
            messageType: MessageType.error);
      }
    } else {
      throw Exception(Strs.failedToLoadDataFromServerErrorMessage.tr);
    }
  }

  static Future<List<Map<String, dynamic>>> getExRequestsFromServer(
      {required String username}) async {
    final func = ParseCloudFunction("getSpecificUserRequests");
    final response = await func.execute(parameters: {"username": username});
    if (response.success) {
      final resultList = (response.result as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      return resultList;
    } else {
      throw Exception(Strs.failedToLoadDataFromServerErrorMessage.tr);
    }
  }

  static Future<ExchangeRequest?> changeExReqStatus({
    required String username,
    required ExchangeRequest req,
    required ExchangeRequestStatus status,
  }) async {
    final func = ParseCloudFunction("changeExReqStatus");
    final response = await func.execute(parameters: {
      "username": username,
      "req": req.parseMap(),
      "status": status.name,
    });
    if (response.success) {
      if ((response.result as Map<String, dynamic>).keys.first == "true") {
        showSnackbar(Strs.operationSuccessfulMessageStr.tr,
            messageType: MessageType.success);
            return ExchangeRequest.fromParse(((response.result as Map<String, dynamic>).values.first as Map<String, dynamic>));
      } else {
        showSnackbar(Strs.failedToRegisterRequestErrorMessage.tr,
            messageType: MessageType.error);
      }
    } else {
      throw Exception(Strs.failedToLoadDataFromServerErrorMessage.tr);
    }
    return null;
  }

  static Future<void> send() async {
    /*{ 
        "to": "<Device FCM token>", 
        "notification": { 
            "title": "Check this Mobile (title)", 
            "body": "Rich Notification testing (body)", 
            "mutable_content": true, 
            "sound": "Tri-tone"
            }, 
        "data": { 
            "url": "<url of media image>", 
            "dl": "<deeplink action on tap of notification>" 
            }
    }*/

    final func = ParseCloudFunction("send");
    final response = await func.execute();
    if (response.success) {
    } else {
      throw Exception(Strs.failedToLoadDataFromServerErrorMessage.tr);
    }
  }

  static Future<void> readMessage(String objectId) async {
    final func = ParseCloudFunction("readMessage");
    final response = await func.execute(parameters: {"objectId": objectId});
    if (response.success) {
    } else {
      throw Exception(Strs.failedToLoadDataFromServerErrorMessage.tr);
    }
  }
}
