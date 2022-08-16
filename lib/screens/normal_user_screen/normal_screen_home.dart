import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../lang/strs.dart';
import '../../main.dart';
import '../../widget/appbar/my_appbar.dart';
import '../../widget/drawer/my_drawer.dart';
import '../../widget/staggered_animations/flutter_staggered_animations.dart';
import 'normal_screen_exchange_req.dart';
import 'normal_screen_holder.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: GetPlatform.isMobile ? getAppBar() : null,
        body: getBody(),
      ),
    );
  }

  Row getBody() {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        if (!GetPlatform.isMobile)
          MyDrawer(sideBarXController: sideBarXController),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: AnimationLimiter(
                key: UniqueKey(),
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    HomeGridChild(
                      index: 0,
                      label: Strs.exchangeReqStr.tr,
                      icon: CupertinoIcons.doc_text,
                      openWidget: const ScreenExchangeReq(),
                    ),
                    HomeGridChild(
                      index: 1,
                      label: Strs.leaveRequestStr.tr,
                      icon: CupertinoIcons.doc_person,
                      openWidget: const Scaffold(
                          body: Center(child: Text('leave request'))),
                    ),
                    HomeGridChild(
                      index: 2,
                      label: Strs.formsStr.tr,
                      icon: CupertinoIcons.doc_plaintext,
                      openWidget:
                          const Scaffold(body: Center(child: Text('forms'))),
                    ),
                    HomeGridChild(
                      index: 3,
                      label: Strs.historyStr.tr,
                      icon: CupertinoIcons.time,
                      openWidget:
                          const Scaffold(body: Center(child: Text('History'))),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget getAppBar() => MyAppBar(
        automaticallyImplyLeading: false,
        title: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {},
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Icon(
                CupertinoIcons.envelope,
                color: Get.theme.colorScheme.primary,
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Text(
                          Strs.appNameStr.tr,
                          key: UniqueKey(),
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
                          child: Icon(
                            CupertinoIcons.bars,
                            color: Get.theme.colorScheme.secondary,
                          ),
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

class HomeGridChild extends StatelessWidget {
  const HomeGridChild({
    Key? key,
    required this.index,
    required this.label,
    required this.icon,
    required this.openWidget,
  }) : super(key: key);

  final int index;
  final String label;
  final IconData icon;
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
                height: double.infinity,
                width: double.infinity,
                child: Card(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            size: 45,
                            color: Get.theme.colorScheme.secondary,
                          ),
                          const SizedBox(height: 10),
                          Text(label),
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
