import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../lang/strs.dart';
import '../../widget/drawer/my_drawer.dart';
import '../../widget/staggered_animations/flutter_staggered_animations.dart';
import 'employee_screen_holder.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
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
                      label: Strs.exchangeRequestStr.tr,
                      icon: CupertinoIcons.doc_text,
                    ),
                    HomeGridChild(
                      index: 1,
                      label: Strs.leaveRequestStr.tr,
                      icon: CupertinoIcons.doc_person,
                    ),
                    HomeGridChild(
                      index: 2,
                      label: Strs.formsStr.tr,
                      icon: CupertinoIcons.doc_plaintext,
                    ),
                    HomeGridChild(
                      index: 3,
                      label: Strs.historyStr.tr,
                      icon: CupertinoIcons.time,
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
    this.onTap,
  }) : super(key: key);

  final int index;
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredGrid(
      columnCount: 3,
      position: index,
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 50,
        child: FadeInAnimation(
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              enableFeedback: false,
              highlightColor: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              onTap: onTap ?? () {},
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
    );
  }
}
