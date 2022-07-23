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
          enablePaddingAnimation: false,
          paddingR: const EdgeInsets.fromLTRB(5, 7.5, 5, 7.5),
          backgroundColor: Get.theme.colorScheme.surface,
          dotIndicatorColor: Get.theme.colorScheme.primary,
          selectedItemColor: Get.theme.colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.onSurface,
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
