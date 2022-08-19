import 'dart:typed_data';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../lang/strs.dart';

typedef OnUserPicked = void Function(MapEntry<String, dynamic> user);

class UserGridTile extends StatelessWidget {
  const UserGridTile({
    Key? key,
    required this.user,
    this.onUserPicked,
  }) : super(key: key);

  final MapEntry<String, dynamic> user;
  final OnUserPicked? onUserPicked;

  @override
  Widget build(BuildContext context) {
    final userPStr = (user.value)['profileImg'] as String?;
    final userPList = userPStr == null || userPStr.isEmpty
        ? null
        : Uint8List.fromList(userPStr.codeUnits);
    return CupertinoContextMenu(
      actions: [
        CupertinoContextMenuAction(
          isDestructiveAction: true,
          onPressed: Get.back,
          trailingIcon: CupertinoIcons.clear,
          child: Center(
            child: Text(
              Strs.cancelStr.tr,
              style:
                  TextStyle(fontFamily: Get.theme.textTheme.button!.fontFamily),
            ),
          ),
        ),
      ],
      child: CupertinoButton(
        onPressed: () {
          onUserPicked?.call(user);
        },
        padding: EdgeInsets.zero,
        child: Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 2,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: Colors.grey,
                        image: const DecorationImage(
                          image: AssetImage('assets/user_avatar.png'),
                          fit: BoxFit.cover,
                        ),
                        shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(
                            cornerRadius: 20,
                            cornerSmoothing: 1,
                          ),
                        ),
                      ),
                      child: userPList != null
                          ? Image.memory(
                              userPList,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/user_avatar.png',
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      children: [
                        Text(
                          (user.value)["name"],
                          style: Get.theme.textTheme.subtitle1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${Strs.teamStr.tr} ${(user.value)["teamName"]} - ${Strs.postStr.tr} ${(user.value)["post"]}",
                          style: Get.theme.textTheme.subtitle2,
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
