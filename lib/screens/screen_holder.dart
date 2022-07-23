import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/bottom_nav_bar/dot_navigation_bar.dart';

final RxInt _selectedTab = 0.obs;

class ScreenHolder extends StatelessWidget {
  const ScreenHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBody: true,
      bottomNavigationBar: Obx(
        () => DotNavigationBar(
          currentIndex: _selectedTab.value,
          onTap: (index) {
            _selectedTab.value = index;
          },
          
          paddingR: const EdgeInsets.fromLTRB(5, 7.5, 5, 7.5),
          backgroundColor: Get.isDarkMode
              ? Get.theme.colorScheme.surface
              : Get.theme.colorScheme.primary,
          dotIndicatorColor: Get.isDarkMode
              ? Theme.of(context).colorScheme.primary
              : Get.theme.colorScheme.surface,
          selectedItemColor: Get.isDarkMode
              ? Get.theme.colorScheme.primary
              : Get.theme.colorScheme.surface,
          unselectedItemColor: Theme.of(context).colorScheme.onPrimary,
          items: [
            DotNavigationBarItem(
              icon: const Icon(CupertinoIcons.home),
            ),
            DotNavigationBarItem(
              icon: const Icon(CupertinoIcons.calendar),
            ),
            DotNavigationBarItem(
              icon: const Icon(CupertinoIcons.person),
            ),
          ],
        ),
      ),
    );
  }
}
