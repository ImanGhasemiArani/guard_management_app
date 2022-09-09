import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

import '../../assets/assets.gen.dart';
import '../../lang/strs.dart';
import '../../services/message_service.dart';
import 'normal_screen_exchanges_tab.dart';

class ScreenMessageBox extends StatelessWidget {
  const ScreenMessageBox({super.key});

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
        child: Text(Strs.messageBoxStr.tr),
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
    final w = Get.width / 3;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(
                () => CupertinoSlidingSegmentedControl(
                  groupValue: selectedTab.value,
                  children: {
                    0: Text(
                      Strs.announcementsStr.tr,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                    1: Text(
                      Strs.conversationsStr.tr,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                    2: Obx(
                      () => Badge(
                        badgeColor: Get.theme.colorScheme.primary,
                        elevation: 0,
                        showBadge: MessageService().badgeCounter != 0,
                        badgeContent: Text("${MessageService().badgeCounter}"),
                        child: Text(
                          Strs.supplyRequestsStr.tr,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  },
                  onValueChanged: (int? index) {
                    selectedTab.value = index ?? 0;
                    pageController.animateToPage(
                      index ?? 0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                    index == 2 ? MessageService().resetBadge() : null;
                  },
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (value) {
                  selectedTab.value = value;
                },
                children: [
                  Scaffold(
                    body: Center(
                      child: Text(Strs.announcementsStr.tr),
                    ),
                  ),
                  Scaffold(
                    body: Center(
                      child: Text(Strs.conversationsStr.tr),
                    ),
                  ),
                  RequestView(selectedFilters: [Strs.supplierReqStr.tr].obs),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
