import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../assets/assets.gen.dart';
import '../../lang/strs.dart';
import '../../main.dart';

class ScreenSettings extends StatelessWidget {
  const ScreenSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              children: [
                _buildThemeSetting(),
                const Divider(thickness: 1, endIndent: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(Strs.settingsStr.tr),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: GestureDetector(
        onTap: Get.back,
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(15),
          child: Assets.icons.arrowLeft3.svg(),
        ),
      ),
    );
  }

  Widget _buildThemeSetting() {
    final ThemeController themeController = Get.find();
    var isSelectedAutomatic = (themeController.mode == ThemeMode.system).obs;
    var isSelectedDarkMode = themeController.mode == ThemeMode.dark;
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strs.themeStr.tr,
            style: TextStyle(
              fontSize: Get.theme.textTheme.headlineSmall!.fontSize,
              height: Get.theme.textTheme.headlineSmall!.height,
              fontStyle: Get.theme.textTheme.headlineSmall!.fontStyle,
              fontWeight: FontWeight.bold,
              letterSpacing: Get.theme.textTheme.headlineSmall!.letterSpacing,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strs.automaticStr.tr,
                style: TextStyle(
                  fontSize: Get.theme.textTheme.headline6!.fontSize,
                  height: Get.theme.textTheme.headline6!.height,
                  fontStyle: Get.theme.textTheme.headline6!.fontStyle,
                  fontWeight: Get.theme.textTheme.headline6!.fontWeight,
                  letterSpacing: Get.theme.textTheme.headline6!.letterSpacing,
                ),
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Transform.scale(
                  scale: 0.8,
                  child: Builder(builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return CupertinoSwitch(
                          activeColor: Get.theme.colorScheme.primary,
                          value: isSelectedAutomatic.value,
                          onChanged: (value) {
                            setState(() {
                              isSelectedAutomatic.value = value;
                            });
                            themeController.mode = value
                                ? ThemeMode.system
                                : isSelectedDarkMode
                                    ? ThemeMode.dark
                                    : ThemeMode.light;
                          },
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strs.darkThemeStr.tr,
                style: TextStyle(
                  fontSize: Get.theme.textTheme.headline6!.fontSize,
                  height: Get.theme.textTheme.headline6!.height,
                  fontStyle: Get.theme.textTheme.headline6!.fontStyle,
                  fontWeight: Get.theme.textTheme.headline6!.fontWeight,
                  letterSpacing: Get.theme.textTheme.headline6!.letterSpacing,
                ),
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Transform.scale(
                  scale: 0.8,
                  child: StatefulBuilder(
                    builder: (context, setState) => Obx(
                      () => CupertinoSwitch(
                        activeColor: Get.theme.colorScheme.primary,
                        value: isSelectedAutomatic.value
                            ? false
                            : isSelectedDarkMode,
                        onChanged: isSelectedAutomatic.value
                            ? null
                            : (value) {
                                setState(() => isSelectedDarkMode = value);
                                themeController.mode =
                                    value ? ThemeMode.dark : ThemeMode.light;
                              },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
