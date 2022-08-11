import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withOpacity(0.8),
      ),
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Get.theme.colorScheme.primary),
              color: Get.theme.colorScheme.background,
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
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
                  child: const Icon(CupertinoIcons.pencil_slash),
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
                  CupertinoButton.filled(
                    onPressed: onSavePressed ?? () {},
                    child: Text(
                      Strs.saveStr.tr,
                      style: TextStyle(
                          fontFamily: Get.theme.textTheme.button!.fontFamily),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
