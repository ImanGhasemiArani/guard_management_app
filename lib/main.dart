import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'init_app_start.dart';
import 'lang/strs.dart';
import 'screens/screen_holder.dart';
import 'services/localization_service.dart';
import 'services/service_locator.dart';
import 'utils/log.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
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
          fontFamily: LocalizationService.fontFamily,
          //   fontFamily: 'Peyda',
          brightness: Brightness.light,
          colorScheme: const ColorScheme.light().copyWith(
            onBackground: const Color(0xff26282b),
            background: const Color(0xffefedff),
            surface: const Color(0xff353941),
            onSurface: const Color(0xffefedff),
            primary: const Color(0xff5f85db),
            onPrimary: const Color(0xffefedff),
            secondary: const Color(0xff90b8f8),
            onSecondary: const Color(0xff26282b),
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          fontFamily: LocalizationService.fontFamily,
          //   fontFamily: 'Peyda',
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark().copyWith(
            background: const Color(0xff26282b),
            onBackground: const Color(0xffefedff),
            surface: const Color(0xff353941),
            onSurface: const Color(0xffefedff),
            primary: const Color(0xff5f85db),
            onPrimary: const Color(0xffefedff),
            secondary: const Color(0xff90b8f8),
            onSecondary: const Color(0xff26282b),
          ),
        ),
        title: Strs.appName,
        home: ScreenApp(),
      );
    });
  }
}

class ScreenApp extends StatelessWidget {
  ScreenApp({Key? key}) : super(key: key) {
    initAppInternetCheck();
    _widget = const ScreenHolder();
    // FlutterNativeSplash.remove();
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
