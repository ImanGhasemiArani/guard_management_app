import 'dart:typed_data';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../assets/assets.gen.dart';
import '../../lang/strs.dart';
import '../../screens/normal_user_screen/normal_shift_picker.dart';
import '../../services/server_service.dart';

typedef OnShiftPicked = void Function(
    MapEntry<DateTime, Map<String, dynamic>> shift);

class ShiftListTile extends StatelessWidget {
  const ShiftListTile({
    Key? key,
    required this.shift,
    this.onShiftPicked,
    this.isShowExchangeableBanner = true,
    this.isFilterCurrentUser = true,
  }) : super(key: key);

  final Map<String, dynamic> shift;
  final OnShiftPicked? onShiftPicked;
  final bool isShowExchangeableBanner;
  final bool isFilterCurrentUser;

  @override
  Widget build(BuildContext context) {
    final userPStr = shift['profileImg'] as String?;
    final userPList = userPStr == null || userPStr.isEmpty
        ? null
        : Uint8List.fromList(userPStr.codeUnits);
    final bool isCurrentUser = isFilterCurrentUser &&
        shift['username'] == ServerService.currentUser.username;
    return CupertinoButton(
      onPressed: shift["shift"]["isExchangeable"] && onShiftPicked != null
          ? () {
              onShiftPicked?.call(MapEntry(currentSelectedDate.value, shift));
            }
          : null,
      padding: EdgeInsets.zero,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: isShowExchangeableBanner || isCurrentUser
              ? Banner(
                  message: shift["shift"]["isExchangeable"]
                      ? Strs.isExchangeableStr.tr
                      : Strs.isNotExchangeableStr.tr,
                  location: BannerLocation.topEnd,
                  textDirection: TextDirection.rtl,
                  color: shift["shift"]["isExchangeable"]
                      ? Colors.green
                      : Colors.red,
                  textStyle: TextStyle(
                    fontFamily: Get.theme.textTheme.button?.fontFamily,
                    color: const Color(0xFFFFFFFF),
                    fontSize: 12 * 0.85,
                    fontWeight: FontWeight.normal,
                    height: 1.0,
                  ),
                  child: _buildBannerChild(userPList),
                )
              : _buildBannerChild(userPList),
        ),
      ),
    );
  }

  Padding _buildBannerChild(Uint8List? userPList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            flex: 1,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                clipBehavior: Clip.antiAlias,
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
                child: userPList != null
                    ? Image.memory(
                        userPList,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Assets.userAvatar.image(fit: BoxFit.cover);
                        },
                      )
                    : null,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${shift["name"]}",
                      style: TextStyle(
                        fontFamily: Get.theme.textTheme.subtitle1?.fontFamily,
                        fontStyle: Get.theme.textTheme.subtitle1?.fontStyle,
                        fontSize: Get.theme.textTheme.subtitle1?.fontSize,
                        fontWeight: Get.theme.textTheme.subtitle1?.fontWeight,
                        letterSpacing:
                            Get.theme.textTheme.subtitle1?.letterSpacing,
                      ),
                    ),
                    Text(
                      "${Strs.teamNameStr.tr}: ${shift["teamName"]} - ${Strs.postStr.tr}: ${shift["post"]}",
                      style: TextStyle(
                        fontFamily: Get.theme.textTheme.subtitle2?.fontFamily,
                        fontStyle: Get.theme.textTheme.subtitle2?.fontStyle,
                        fontSize: Get.theme.textTheme.subtitle2?.fontSize,
                        fontWeight: Get.theme.textTheme.subtitle2?.fontWeight,
                        letterSpacing:
                            Get.theme.textTheme.subtitle2?.letterSpacing,
                      ),
                    ),
                    Text(
                      shift["shift"]["des"],
                      style: TextStyle(
                        fontFamily: Get.theme.textTheme.bodyText2?.fontFamily,
                        fontStyle: Get.theme.textTheme.bodyText2?.fontStyle,
                        fontSize: Get.theme.textTheme.bodyText2?.fontSize,
                        fontWeight: Get.theme.textTheme.bodyText2?.fontWeight,
                        letterSpacing:
                            Get.theme.textTheme.bodyText2?.letterSpacing,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
