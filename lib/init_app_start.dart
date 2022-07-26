import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/localization_service.dart';
import 'services/service_locator.dart';

Future<void> initAppStart() async {
  sharedPreferences = await SharedPreferences.getInstance();
  secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  Get.put(LocalizationService('فارسی'));
}
