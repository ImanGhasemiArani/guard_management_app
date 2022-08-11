import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'init_app_start.dart';
import 'lang/strs.dart';
import 'screens/screen_log_in.dart';
import 'services/localization_service.dart';
import 'services/server_service.dart';
import 'services/service_locator.dart';
import 'utils/log.dart';
import 'widget/loading_widget/loading_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
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
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        locale: localizationService.locale,
        fallbackLocale: LocalizationService.fallBackLocale,
        translations: localizationService,
        textDirection: TextDirection.ltr,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
          useMaterial3: true,
          fontFamily: LocalizationService.fontFamily,
          textTheme: const TextTheme().copyWith(
            button: const TextStyle().copyWith(
              fontFamily: LocalizationService.fontFamily,
            ),
          ),
          appBarTheme: const AppBarTheme().copyWith(
            color: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          cardTheme: const CardTheme(
            elevation: 8,
          ),
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xff001021),
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
        home: const ScreenApp(),
      );
    });
  }
}

class ScreenApp extends StatelessWidget {
  const ScreenApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: setupServices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if ((snapshot.data as MapEntry<bool, String?>).key) {
              return currentUser.screenHolder;
            } else {
              return ScreenLogin();
            }
          } else {
            return const ScreenSplash();
          }
        },
      ),
    );
  }
}

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: LoadingWidget(),
    );
  }
}
