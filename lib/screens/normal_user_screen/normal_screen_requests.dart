import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

import '../../assets/assets.gen.dart';
import '../../lang/strs.dart';

class ScreenRequests extends StatelessWidget {
  const ScreenRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: const BodyWidget(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(Strs.requestsStr.tr),
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
}

class BodyWidget extends HookWidget {
  const BodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var pageController = usePageController();
    final selectedTab = 0.obs;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Obx(
              () => CupertinoSlidingSegmentedControl(
                groupValue: selectedTab.value,
                children: const {
                  0: Text(Strs.exchangesStr),
                  1: Text(Strs.leavesStr),
                },
                onValueChanged: (int? index) {
                  selectedTab.value = index ?? 0;
                  pageController.animateToPage(
                    index ?? 0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              children: const [
                Scaffold(
                  body: Center(child: Text(Strs.exchangesStr)),
                ),
                Scaffold(
                  body: Center(child: Text(Strs.leavesStr)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
