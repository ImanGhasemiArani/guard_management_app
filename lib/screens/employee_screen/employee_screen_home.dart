import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../lang/strs.dart';
import '../../widget/drawer/my_drawer.dart';
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
        appBar: GetPlatform.isMobile
            ? AppBar(
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
              )
            : null,
        body: Row(
          textDirection: TextDirection.rtl,
          children: [
            if (!GetPlatform.isMobile)
              MyDrawer(sideBarXController: sideBarXController),
            Expanded(
              child: Obx(
                () {
                  switch (selectedIndexDrawer.value) {
                    case 0:
                      return Center(
                        child: Text(Strs.homeStr.tr),
                      );
                    case 1:
                      return Center(
                        child: Text(Strs.profileStr.tr),
                      );
                    default:
                      return Center(
                        child: Text(Strs.homeStr.tr),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
