import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guard_management_app/main.dart';

import '../../lang/strs.dart';

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
          child: const Icon(
            CupertinoIcons.chevron_back,
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSetting() {
    final ThemeController themeController = Get.find();
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
                    builder: (context, setState) {
                      return CupertinoSwitch(
                        activeColor: Get.theme.colorScheme.primary,
                        value: isSelectedDarkMode,
                        onChanged: (value) {
                          setState(() => isSelectedDarkMode = value);
                          themeController.mode =
                              value ? ThemeMode.dark : ThemeMode.light;
                        },
                      );
                    },
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
