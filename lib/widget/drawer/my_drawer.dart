import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../lang/strs.dart';
import '../../services/server_service.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
    required SidebarXController sideBarXController,
  })  : _sideBarXController = sideBarXController,
        super(key: key);

  final SidebarXController _sideBarXController;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SidebarX(
        controller: _sideBarXController,
        theme: SidebarXTheme(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: TextStyle(color: Get.theme.colorScheme.onSurface),
          selectedTextStyle: TextStyle(color: Get.theme.colorScheme.primary),
          itemTextPadding: const EdgeInsets.only(right: 30),
          selectedItemTextPadding: const EdgeInsets.only(right: 30),
          itemDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Get.theme.colorScheme.surface),
          ),
          selectedItemDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFF5F5FA7).withOpacity(0.6).withOpacity(0.37),
            ),
            gradient: LinearGradient(
              colors: [const Color(0xFF3E3E61), Get.theme.colorScheme.surface],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.28),
                blurRadius: 30,
              )
            ],
          ),
          iconTheme: IconThemeData(
            color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
            size: 20,
          ),
          selectedIconTheme: IconThemeData(
            color: Get.theme.colorScheme.primary,
            size: 20,
          ),
        ),
        extendedTheme: SidebarXTheme(
          width: 200,
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.surface,
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(20),
            ),
          ),
        ),
        footerDivider: Divider(color: Colors.white.withOpacity(0.3), height: 1),
        headerBuilder: (context, extended) => extended
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          'assets/user_avatar.png',
                        ),
                      ),
                    ),
                    Text("${currentUser.name}"),
                    Text("${currentUser.nationalId}"),
                  ],
                ),
              )
            : SizedBox(
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset('assets/user_avatar.png'),
                  ),
                ),
              ),
        items: [
          SidebarXItem(
            icon: CupertinoIcons.home,
            label: Strs.homeStr.tr,
            onTap: () {},
          ),
          SidebarXItem(
            icon: CupertinoIcons.person,
            label: Strs.profileStr.tr,
            onTap: () {},
          ),
          SidebarXItem(
            icon: Icons.logout_rounded,
            label: Strs.logoutStr.tr,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
