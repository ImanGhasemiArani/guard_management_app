import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/btn_nav_bar/button_navigation_bar.dart';
import 'screen_account.dart';
import 'screen_calender.dart';
import 'screen_home.dart';

// ignore: must_be_immutable
class ScreenHolder extends HookWidget {
  ScreenHolder({Key? key}) : super(key: key);

  late PageController _pageController;

  @override
  Widget build(BuildContext context) {
    _pageController = usePageController(initialPage: 1);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBody: true,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          const ScreenCalender(),
          const ScreenHome(),
          ScreenAccount(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BtnNavBar(pageController: _pageController),
    );
  }
}

class BtnNavBar extends StatelessWidget {
  const BtnNavBar({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final RxInt selectedTab = 1.obs;
    var selectedColor = Get.theme.colorScheme.primary;
    var backgroundColorItem = Get.theme.colorScheme.surface;
    return Obx(
      () => ButtonNavigationBar(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        children: [
          ButtonNavigationItem(
            icon: Icon(
              CupertinoIcons.calendar,
              color: selectedTab.value == 0 ? selectedColor : null,
            ),
            color: backgroundColorItem,
            onPressed: () {
              FocusManager.instance.primaryFocus!.unfocus();
              pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              selectedTab.value = 0;
            },
          ),
          ButtonNavigationItem(
            icon: Icon(
              CupertinoIcons.home,
              color: selectedTab.value == 1 ? selectedColor : null,
            ),
            color: backgroundColorItem,
            onPressed: () {
              FocusManager.instance.primaryFocus!.unfocus();
              pageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              selectedTab.value = 1;
            },
          ),
          ButtonNavigationItem(
            icon: Icon(
              CupertinoIcons.person,
              color: selectedTab.value == 2 ? selectedColor : null,
            ),
            color: backgroundColorItem,
            onPressed: () {
              FocusManager.instance.primaryFocus!.unfocus();
              pageController.animateToPage(
                2,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              selectedTab.value = 2;
            },
          ),
        ],
      ),
    );
  }
}
