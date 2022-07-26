import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../widget/btn_nav_bar/button_navigation_bar.dart';
import '../../widget/drawer/my_drawer.dart';
import '../screen_holder.dart';
import 'normal_screen_settings.dart';
import 'normal_screen_user_profile.dart';
import 'normal_screen_home.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
SidebarXController sideBarXController = SidebarXController(selectedIndex: 0);
RxInt selectedIndexDrawer = 0.obs;
RxBool isSideBarExpanded = false.obs;

// ignore: must_be_immutable
class NormalScreenHolder extends ScreenHolder {
  const NormalScreenHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    setupDrawer();
    return Scaffold(
      key: scaffoldKey,
      extendBody: true,
      body: const ScreenHome(),
      //   floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //   floatingActionButton: BtnNavBar(pageController: _pageController),
      endDrawerEnableOpenDragGesture: false,
      endDrawer: SafeArea(
        child: MyDrawer(sideBarXController: sideBarXController),
      ),
    );
  }

  void setupDrawer() {
    sideBarXController = SidebarXController(selectedIndex: 0);
    selectedIndexDrawer = 0.obs;
    isSideBarExpanded = false.obs;
    sideBarXController.addListener(() {
      if (selectedIndexDrawer.value != sideBarXController.selectedIndex) {
        selectedIndexDrawer.value = sideBarXController.selectedIndex;
        final value = sideBarXController.selectedIndex;
        sideBarXController.selectIndex(0);
        if (value == 1) {
          Get.to(const ScreenUserProfile(), transition: Transition.cupertino);
        } else if (value == 2) {
          Get.to(const ScreenSettings(), transition: Transition.cupertino);
        } else if ([0, 7].contains(value)) {
        } else {
          Get.to(const Scaffold());
        }
        scaffoldKey.currentState!.closeEndDrawer();
      } else if (isSideBarExpanded.value != sideBarXController.extended) {
        isSideBarExpanded.value = sideBarXController.extended;
      } else {
        scaffoldKey.currentState!.closeEndDrawer();
      }
    });
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
        ],
      ),
    );
  }
}
