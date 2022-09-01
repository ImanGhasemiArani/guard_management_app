import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../assets/assets.gen.dart';
import '../../lang/strs.dart';
import '../../widget/appbar/my_appbar.dart';
import '../../widget/drawer/my_drawer.dart';
import '../../widget/staggered_animations/flutter_staggered_animations.dart';
import 'normal_screen_exchange_req.dart';
import 'normal_screen_holder.dart';
import 'normal_screen_message_box.dart';
import 'normal_screen_requests.dart';
import 'normal_screen_shift_schedule.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GetPlatform.isMobile ? getAppBar() : null,
      body: getBody(),
    );
  }

  Row getBody() {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        if (!GetPlatform.isMobile)
          MyDrawer(sideBarXController: sideBarXController),
        Expanded(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: AnimationLimiter(
              key: UniqueKey(),
              child: GridView.count(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(30),
                clipBehavior: Clip.none,
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  HomeGridChild(
                    index: 0,
                    label: Strs.shiftScheduleStr.tr,
                    iconWidget: Assets.icons.calendar.svg(size: 45),
                    openWidget: const ScreenShiftSchedule(),
                  ),
                  HomeGridChild(
                    index: 1,
                    label: Strs.exchangeReqStr.tr,
                    iconWidget: Assets.icons.documentText.svg(size: 45),
                    openWidget: const ScreenExchangeReq(),
                  ),
                  HomeGridChild(
                    index: 2,
                    label: Strs.leaveRequestStr.tr,
                    iconWidget: Assets.icons.note1.svg(size: 45),
                    openWidget: const Scaffold(
                        body: Center(child: Text('leave request'))),
                  ),
                  HomeGridChild(
                    index: 3,
                    label: Strs.formsStr.tr,
                    iconWidget: Assets.icons.note2.svg(size: 45),
                    openWidget:
                        const Scaffold(body: Center(child: Text('forms'))),
                  ),
                  HomeGridChild(
                    index: 4,
                    label: Strs.requestsStr.tr,
                    iconWidget: Assets.icons.receiptItem.svg(size: 45),
                    openWidget: const ScreenRequests(),
                  ),
                  HomeGridChild(
                    index: 5,
                    label: Strs.historyStr.tr,
                    iconWidget: Assets.icons.clock.svg(size: 45),
                    openWidget:
                        const Scaffold(body: Center(child: Text('History'))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget getAppBar() => MyAppBar(
        automaticallyImplyLeading: false,
        title: OpenContainer(
          closedElevation: 0,
          openElevation: 0,
          clipBehavior: Clip.none,
          closedColor: Colors.transparent,
          openColor: Colors.transparent,
          middleColor: Colors.transparent,
          openBuilder: ((context, action) => const ScreenMessageBox()),
          closedBuilder: (context, action) => CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: action,
            child: Card(
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 15,
                  cornerSmoothing: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Assets.icons.directNormal.svg(),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: scaffoldKey.currentState!.openEndDrawer,
              child: SizedBox(
                height: double.infinity,
                child: Card(
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                      cornerRadius: 15,
                      cornerSmoothing: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Text(
                          Strs.appNameStr.tr,
                          style: TextStyle(
                            fontSize: Get.theme.textTheme.headline6!.fontSize,
                            height: Get.theme.textTheme.headline6!.height,
                            fontStyle: Get.theme.textTheme.headline6!.fontStyle,
                            fontWeight:
                                Get.theme.textTheme.headline6!.fontWeight,
                            letterSpacing:
                                Get.theme.textTheme.headline6!.letterSpacing,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Assets.icons.menu1.svg(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}

AutoSizeGroup group = AutoSizeGroup();

class HomeGridChild extends StatelessWidget {
  const HomeGridChild({
    Key? key,
    required this.index,
    required this.label,
    required this.iconWidget,
    required this.openWidget,
  }) : super(key: key);

  final int index;
  final String label;
  final Widget iconWidget;
  final Widget openWidget;

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredGrid(
      columnCount: 3,
      position: index,
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 50,
        child: FadeInAnimation(
          child: OpenContainer(
            closedElevation: 0,
            openElevation: 0,
            clipBehavior: Clip.none,
            closedColor: Colors.transparent,
            openColor: Colors.transparent,
            middleColor: Colors.transparent,
            openBuilder: ((context, action) => openWidget),
            closedBuilder: (context, action) => CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: action,
              child: SizedBox(
                child: Card(
                  child: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: iconWidget,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: AutoSizeText(
                                label,
                                style: TextStyle(
                                  fontFamily: Get
                                      .theme.textTheme.labelLarge?.fontFamily,
                                  fontStyle:
                                      Get.theme.textTheme.labelLarge?.fontStyle,
                                  fontSize:
                                      Get.theme.textTheme.labelLarge?.fontSize,
                                  fontWeight: Get
                                      .theme.textTheme.labelLarge?.fontWeight,
                                  letterSpacing: Get.theme.textTheme.labelLarge
                                      ?.letterSpacing,
                                ),
                                group: group,
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 5,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
