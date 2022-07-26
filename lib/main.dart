import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
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
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
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
      final ThemeController themeController = Get.find();
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        locale: localizationService.locale,
        fallbackLocale: LocalizationService.fallBackLocale,
        translations: localizationService,
        textDirection: TextDirection.ltr,
        themeMode: themeController.mode,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: LocalizationService.fontFamily,
          textTheme: const TextTheme().copyWith(
            button: const TextStyle().copyWith(
              fontFamily: LocalizationService.fontFamily,
            ),
          ),
          appBarTheme: const AppBarTheme().copyWith(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            color: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          cardTheme: CardTheme(
            clipBehavior: Clip.antiAlias,
            elevation: 8,
            color: const Color(0xffFFFFFF),
            surfaceTintColor: const Color(0xffFFFFFF),
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 20,
                cornerSmoothing: 1,
              ),
            ),
          ),
          iconTheme: const IconThemeData(
            color: Color(0xff00AFCE),
          ),
          brightness: Brightness.light,
          scaffoldBackgroundColor: const Color(0xffF4FAFA),
          colorScheme: const ColorScheme.light().copyWith(
            background: const Color(0xffF4FAFA),
            onBackground: const Color(0xff353334),
            surface: const Color(0xffFFFFFF),
            onSurface: const Color(0xff353334),
            primary: const Color(0xffF38138),
            secondary: const Color(0xff00AFCE),
            tertiary: const Color(0xff008001),
            errorContainer: const Color(0xFFF44336).withOpacity(0.5),
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          fontFamily: LocalizationService.fontFamily,
          textTheme: const TextTheme().copyWith(
            button: const TextStyle().copyWith(
              fontFamily: LocalizationService.fontFamily,
            ),
          ),
          appBarTheme: const AppBarTheme().copyWith(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            color: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          cardTheme: CardTheme(
            clipBehavior: Clip.antiAlias,
            elevation: 8,
            color: const Color(0xff16202A),
            surfaceTintColor: const Color(0xff16202A),
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 20,
                cornerSmoothing: 1,
              ),
            ),
          ),
          iconTheme: const IconThemeData(
            color: Color(0xff00AFCE),
          ),
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xff192734),
          colorScheme: const ColorScheme.dark().copyWith(
            background: const Color(0xff192734),
            onBackground: const Color(0xffFAFAFA),
            surface: const Color(0xff16202A),
            onSurface: const Color(0xffFAFAFA),
            primary: const Color(0xffF38138),
            secondary: const Color(0xff00AFCE),
            tertiary: const Color(0xff008001),
            errorContainer: const Color(0xFFF44336).withOpacity(0.5),
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
            FlutterNativeSplash.remove();
            if ((snapshot.data as MapEntry<bool, String?>).key) {
              return ServerService.currentUser.screenHolder;
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

class ThemeController {
  late ThemeMode _mode;

  ThemeController(ThemeMode mode) {
    _mode = mode;
  }

  ThemeMode get mode => _mode;

  set mode(ThemeMode themeMode) {
    _mode = themeMode;
    Get.changeThemeMode(mode);

    // Future.delayed(
    //     const Duration(milliseconds: 500), (() => Get.changeThemeMode(mode)));
    sharedPreferences.setString("themeMode", _mode.name);
  }
}
