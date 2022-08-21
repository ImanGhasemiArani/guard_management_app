import 'dart:typed_data';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../lang/strs.dart';
import '../../screens/normal_user_screen/normal_shift_picker.dart';

typedef OnShiftPicked = void Function(
    MapEntry<DateTime, Map<String, dynamic>> shift);

class ShiftListTile extends StatelessWidget {
  const ShiftListTile({
    Key? key,
    required this.shift,
    this.onShiftPicked,
  }) : super(key: key);

  final Map<String, dynamic> shift;
  final OnShiftPicked? onShiftPicked;

  @override
  Widget build(BuildContext context) {
    final userPStr = shift['profileImg'] as String?;
    final userPList = userPStr == null || userPStr.isEmpty
        ? null
        : Uint8List.fromList(userPStr.codeUnits);
    return CupertinoButton(
      onPressed: shift["shift"]["isExchangeable"]
          ? () {
              onShiftPicked?.call(MapEntry(currentSelectedDate.value, shift));
            }
          : null,
      padding: EdgeInsets.zero,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Banner(
            message: shift["shift"]["isExchangeable"]
                ? Strs.isExchangeableStr.tr
                : Strs.isNotExchangeableStr.tr,
            location: BannerLocation.topEnd,
            textDirection: TextDirection.rtl,
            color: shift["shift"]["isExchangeable"] ? Colors.green : Colors.red,
            textStyle: TextStyle(
              fontFamily: Get.theme.textTheme.button?.fontFamily,
              color: const Color(0xFFFFFFFF),
              fontSize: 12 * 0.85,
              fontWeight: FontWeight.normal,
              height: 1.0,
            ),
            child: Padding(
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
                    flex: 3,
                    child: Container(
                      //   color: Colors.green,
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
                                style: Get.theme.textTheme.subtitle1,
                              ),
                              Text(
                                "${Strs.teamNameStr.tr}: ${shift["teamName"]} - ${Strs.postStr.tr}: ${shift["post"]}",
                                style: Get.theme.textTheme.subtitle2,
                              ),
                              Text(
                                shift["shift"]["des"],
                                style: Get.theme.textTheme.bodyText2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // if (!shift["shift"]["isExchangeable"])
                  //   Text(Strs.isNotExchangeableStr.tr,
                  //       style: Get.theme.textTheme.subtitle2!.copyWith(
                  //         color: Get.theme.colorScheme.primary,
                  //       )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
