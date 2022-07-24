import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import 'init_app_start.dart';
import 'lang/strs.dart';
import 'screens/screen_holder.dart';
import 'screens/screen_log_in.dart';
import 'services/localization_service.dart';
import 'services/service_locator.dart';
import 'utils/log.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  await initAppStart();
  runApp(const MainMaterial());
}

class MainMaterial extends StatelessWidget {
  const MainMaterial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logging("Start App", isShowTime: true);
    LocalizationService localizationService = Get.find();
    return Builder(builder: (context) {
      //   final ThemeController themeController = Get.find();
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        locale: localizationService.locale,
        fallbackLocale: LocalizationService.fallBackLocale,
        translations: localizationService,
        textDirection: TextDirection.ltr,
        // themeMode: themeController.mode,
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          useMaterial3: true,
          //   fontFamily: 'Peyda',
          fontFamily: LocalizationService.fontFamily,
          textTheme: const TextTheme().copyWith(
            button: const TextStyle().copyWith(
              fontFamily: LocalizationService.fontFamily,
            ),
          ),
          brightness: Brightness.light,
          colorScheme: const ColorScheme.light().copyWith(
            background: const Color(0xffefedff),
            onBackground: const Color(0xff26282b),
            surface: const Color(0xff353941),
            onSurface: const Color(0xffefedff),
            primary: const Color(0xff5f85db),
            onPrimary: const Color(0xffefedff),
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          //   fontFamily: 'Peyda',
          fontFamily: LocalizationService.fontFamily,
          textTheme: const TextTheme().copyWith(
            button: const TextStyle().copyWith(
              fontFamily: LocalizationService.fontFamily,
            ),
          ),
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark().copyWith(
            background: const Color(0xff001021),
            onBackground: const Color(0xffefedff),
            surface: const Color(0xff0a174e),
            onSurface: const Color(0xffefedff),
            primary: const Color(0xfff5d042),
            onPrimary: const Color(0xff0a174e),
          ),
        ),
        title: Strs.appNameStr,
        home: ScreenApp(),
      );
    });
  }
}

class ScreenApp extends StatelessWidget {
  ScreenApp({Key? key}) : super(key: key) {
    // _widget = const ScreenHolder();
    setupServiceLocator();
    checkUserIsLoginAndLogin();
    _widget = const ScreenLogIn();
    FlutterNativeSplash.remove();
  }
  late final Widget _widget;

  @override
  Widget build(BuildContext context) {
    return _widget;
  }
}

class ThemeController {
  late ThemeMode _mode;

  ThemeController(this._mode);

  ThemeMode get mode => _mode;

  set mode(ThemeMode themeMode) {
    _mode = themeMode;
    sharedPreferences.setString("themeMode", _mode.name);
  }
}
