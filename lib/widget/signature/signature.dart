import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../assets/assets.gen.dart';
import '../../lang/strs.dart';

class Signature extends StatelessWidget {
  const Signature({
    Key? key,
    required this.signatureKey,
    this.onSavePressed,
  }) : super(key: key);

  final GlobalKey<SfSignaturePadState> signatureKey;
  final VoidCallback? onSavePressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: Get.width,
                child: Text(
                  Strs.signStr.tr,
                  style: Get.theme.textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              height: Get.width - 80,
              decoration: ShapeDecoration(
                color: Get.theme.colorScheme.background,
                shape: SmoothRectangleBorder(
                  side: BorderSide(color: Get.theme.colorScheme.primary),
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 20,
                    cornerSmoothing: 1,
                  ),
                ),
              ),
              child: Stack(
                children: [
                  ClipSmoothRect(
                    radius: SmoothBorderRadius(
                      cornerRadius: 20,
                      cornerSmoothing: 1,
                    ),
                    child: SfSignaturePad(
                      key: signatureKey,
                      backgroundColor: Colors.transparent,
                      strokeColor: Get.theme.colorScheme.onBackground,
                      minimumStrokeWidth: 1,
                      maximumStrokeWidth: 4,
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () => signatureKey.currentState!.clear(),
                    child: Assets.icons.eraser1.svg(),
                  )
                ],
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CupertinoButton(
                      onPressed: Get.back,
                      child: Text(
                        Strs.cancelStr.tr,
                        style: TextStyle(
                          fontFamily: Get.theme.textTheme.button!.fontFamily,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    ClipSmoothRect(
                      radius: SmoothBorderRadius(
                        cornerRadius: 10,
                        cornerSmoothing: 1,
                      ),
                      child: CupertinoButton.filled(
                        onPressed: onSavePressed ?? () {},
                        child: Text(
                          Strs.saveStr.tr,
                          style: TextStyle(
                              fontFamily:
                                  Get.theme.textTheme.button!.fontFamily),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
