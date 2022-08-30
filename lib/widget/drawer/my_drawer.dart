import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../assets/assets.gen.dart';
import '../../lang/strs.dart';
import '../../screens/screen_log_in.dart';
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
      child: ClipSmoothRect(
        radius: const SmoothBorderRadius.only(
          topLeft: SmoothRadius(
            cornerRadius: 50,
            cornerSmoothing: 1,
          ),
          bottomLeft: SmoothRadius(
            cornerRadius: 50,
            cornerSmoothing: 1,
          ),
        ),
        child: SidebarX(
          controller: _sideBarXController,
          theme: SidebarXTheme(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            textStyle: TextStyle(color: Get.theme.colorScheme.onSurface),
            selectedTextStyle:
                TextStyle(color: Get.theme.colorScheme.onSurface),
            itemTextPadding: const EdgeInsets.only(right: 30),
            selectedItemTextPadding: const EdgeInsets.only(right: 30),
            // selectedTextStyle: TextStyle(color: Get.theme.colorScheme.primary),
            // selectedItemTextPadding: const EdgeInsets.only(right: 30),
            // itemDecoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(10),
            //   border: Border.all(color: Get.theme.colorScheme.surface),
            // ),
            //   selectedItemDecoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     border: Border.all(color: Get.theme.colorScheme.surface),
            //   ),
            // selectedItemDecoration: BoxDecoration(
            //   borderRadius: SmoothBorderRadius(
            //     cornerRadius: 15,
            //     cornerSmoothing: 1,
            //   ),
            //   border: Border.all(
            //       color: Get.theme.colorScheme.secondary, width: 1.5),
            //   color: Get.theme.colorScheme.secondary.withOpacity(0.1),
            //   // gradient: LinearGradient(
            //   //   colors: [
            //   //     const Color(0xFF3E3E61),
            //   //     Get.theme.colorScheme.surface,
            //   //   ],
            //   // ),
            //   // boxShadow: [
            //   //   BoxShadow(
            //   //     color: Colors.black.withOpacity(0.28),
            //   //     blurRadius: 30,
            //   //   )
            //   // ],
            // ),
            // iconTheme: IconThemeData(
            //   color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
            //   size: 20,
            // ),
            //   selectedIconTheme: IconThemeData(
            //     color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
            //     size: 20,
            //   ),
            // selectedIconTheme: IconThemeData(
            //   color: Get.theme.colorScheme.primary,
            //   size: 20,
            // ),
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
          // footerDivider:
          //     Divider(color: Colors.white.withOpacity(0.3), height: 1),
          headerBuilder: (context, extended) {
            final imgUint8List = ServerService.currentUser.profileImage;
            return extended
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: ShapeDecoration(
                            color: Colors.grey,
                            image: DecorationImage(
                              image: Assets.userAvatar.image().image,
                              fit: BoxFit.cover,
                            ),
                            shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius(
                                cornerRadius: 20,
                                cornerSmoothing: 1,
                              ),
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: imgUint8List != null
                              ? Image.memory(
                                  imgUint8List,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Assets.userAvatar
                                        .image(fit: BoxFit.cover);
                                  },
                                )
                              : null,
                        ),
                        const SizedBox(height: 10),
                        Text("${ServerService.currentUser.name}"),
                        const SizedBox(height: 5),
                        Text("${ServerService.currentUser.username}"),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 40),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: ShapeDecoration(
                        color: Colors.grey,
                        image: DecorationImage(
                          image: Assets.userAvatar.image().image,
                          fit: BoxFit.cover,
                        ),
                        shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(
                            cornerRadius: 15,
                            cornerSmoothing: 1,
                          ),
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: imgUint8List != null
                          ? Image.memory(
                              imgUint8List,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Assets.userAvatar
                                    .image(fit: BoxFit.cover);
                              },
                            )
                          : null,
                    ),
                  );
          },
          footerBuilder: (context, extended) {
            return extended
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        Text(
                          Strs.appNameStr.tr,
                          style: Get.theme.textTheme.headline6,
                        ),
                        Text(Strs.appFullNameStr.tr),
                        Text(Strs.appVersionStr.tr),
                      ],
                    ),
                  )
                : const SizedBox();
          },
          toggleButtonBuilder: (context, extended) {
            return InkWell(
              key: const Key('sidebarx_toggle_button'),
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: () {
                _sideBarXController.toggleExtended();
              },
              enableFeedback: false,
              child: Row(
                mainAxisAlignment: _sideBarXController.extended
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: _sideBarXController.extended
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: RotatedBox(
                              quarterTurns: 2,
                              child: Assets.icons.arrowLeft3.svg(size: 20),
                            ),
                          )
                        : Assets.icons.arrowLeft3.svg(size: 20),
                  ),
                ],
              ),
            );
          },
          items: [
            SidebarXItem(
              iconWidget: Assets.icons.home1.svg(),
              label: Strs.homeStr.tr,
              onTap: () {},
            ),
            SidebarXItem(
              iconWidget: Assets.icons.profile.svg(),
              label: Strs.profileStr.tr,
              onTap: () {},
            ),
            SidebarXItem(
              iconWidget: Assets.icons.setting2.svg(),
              label: Strs.settingsStr.tr,
              onTap: () {},
            ),
            SidebarXItem(
              iconWidget: Assets.icons.information.svg(),
              label: Strs.guideStr.tr,
              onTap: () {},
            ),
            SidebarXItem(
              iconWidget: Assets.icons.people.svg(),
              label: Strs.supportStr.tr,
              onTap: () {},
            ),
            SidebarXItem(
              iconWidget: Assets.icons.securitySafe.svg(),
              label: Strs.termsAndConditionsStr.tr,
              onTap: () {},
            ),
            SidebarXItem(
              iconWidget: Assets.icons.information.svg(),
              label: Strs.aboutAppStr.tr,
              onTap: () {},
            ),
            SidebarXItem(
              iconWidget: Assets.icons.logout.svg(),
              label: Strs.logoutStr.tr,
              onTap: () {
                ServerService.logoutUser()
                    .then((value) => Get.off(ScreenLogin()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
