import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../lang/strs.dart';
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

  AppBar getAppBar() => AppBar(
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {},
          child: const Card(
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Icon(CupertinoIcons.envelope),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Text(
                        Strs.appNameStr.tr,
                        style: Get.theme.textTheme.headline6,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Icon(CupertinoIcons.bars),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                scaffoldKey.currentState!.openEndDrawer();
              },
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
            closedColor: Colors.transparent,
            openColor: Colors.transparent,
            middleColor: Colors.transparent,
            openBuilder: ((context, action) => openWidget),
            closedBuilder: (context, action) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                enableFeedback: false,
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                onTap: action,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(icon, size: 45),
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
    );
  }
}
