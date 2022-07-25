import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/btn_nav_bar/button_navigation_bar.dart';
import 'screen_account.dart';

final PageController _controller = PageController(initialPage: 1);

class ScreenHolder extends StatefulWidget {
  const ScreenHolder({Key? key}) : super(key: key);

  @override
  State<ScreenHolder> createState() => _ScreenHolderState();
}

class _ScreenHolderState extends State<ScreenHolder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBody: true,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        children: [
          Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: const Center(
              child: Text('تقویم'),
            ),
          ),
          Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: const Center(
              child: Text('خانه'),
            ),
          ),
          ScreenAccount(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _getBtnNavBar(),
    );
  }

  Widget _getBtnNavBar() {
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
              _controller.animateToPage(
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
              _controller.animateToPage(
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
              _controller.animateToPage(
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
