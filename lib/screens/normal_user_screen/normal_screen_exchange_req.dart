import 'dart:typed_data';
import 'dart:ui';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../assets/assets.gen.dart';
import '../../lang/strs.dart';
import '../../model/exchange_request.dart';
import '../../services/pdf_service.dart';
import '../../services/server_service.dart';
import '../../utils/show_toast.dart';
import '../../widget/signature/signature.dart';
import 'normal_shift_picker.dart';
import 'normal_user_picker.dart';
import '../../widget/bottom_sheet_modal/floating_modal.dart';

ExchangeRequest exchangeRequest = ExchangeRequest(
  ServerService.currentUser.username!,
  ServerService.currentUser.name,
  ServerService.currentUser.organPos,
);

class ScreenExchangeReq extends StatelessWidget {
  const ScreenExchangeReq({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    exchangeRequest = ExchangeRequest(
      ServerService.currentUser.username!,
      ServerService.currentUser.name,
      ServerService.currentUser.organPos,
    );
    return Scaffold(
      appBar: getAppBar(),
      body: Column(
        children: [
          Expanded(child: getBody()),
          getSendButton(),
        ],
      ),
    );
  }

  SingleChildScrollView getBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: SizedBox(
          width: double.infinity,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getChangerReqWidget(),
                const SizedBox(height: 30),
                getSupplierReqWidget(),
                const SizedBox(height: 30),
                getChangerSignatureWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(Strs.exchangeReqFormStr.tr),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: GestureDetector(
        onTap: Get.back,
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(15),
          child: Assets.icons.arrowLeft3.svg(),
        ),
      ),
    );
  }

  Widget getChangerReqWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${Strs.changerReqStr.tr}: "),
        const SizedBox(height: 10),
        Text(
          ServerService.currentUser.name!,
          style: Get.theme.textTheme.bodyLarge,
        ),
        Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text("${Strs.changerShiftStr.tr}: "),
            CupertinoButton(
              child: Text(
                Strs.selectPleaseStr.tr,
                style: TextStyle(
                    fontFamily: Get.theme.textTheme.button!.fontFamily),
              ),
              onPressed: () {
                showBarModalBottomSheet(
                    shape: const SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius.vertical(
                        top: SmoothRadius(
                          cornerRadius: 40,
                          cornerSmoothing: 1,
                        ),
                      ),
                    ),
                    context: Get.context!,
                    builder: (context) {
                      return ShiftPicker(
                        onShiftPicked: (shift) {
                          var f = Jalali.fromDateTime(shift.key).formatter;
                          exchangeRequest.changerShiftDate =
                              "${f.d}  ${f.mN}  ${f.y}";
                          exchangeRequest.changerShiftDescription =
                              shift.value['shift']['des'];
                          Get.back();
                        },
                        future: Future.sync(() async {
                          final f = Jalali.now().formatter;
                          return await ServerService.getSpecificUserSchedule(
                            username: ServerService.currentUser.username!,
                            isOnlyGuard: true,
                            isFilterDate: true,
                            afterDate: "${f.y}-${f.m}-${f.d}",
                          );
                        }),
                      );
                    });
              },
            ),
          ],
        ),
        Obx(
          () {
            return Visibility(
              visible: exchangeRequest.changerShiftDate != null,
              child: getShiftContent(),
            );
          },
        ),
      ],
    );
  }

  Card getShiftContent() {
    return Card(
      shape: SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: 15,
          cornerSmoothing: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "${exchangeRequest.changerShiftDate}",
              style: Get.theme.textTheme.headline6,
            ),
            Text(
              "${exchangeRequest.changerShiftDescription}",
              style: Get.theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget getSupplierReqWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text("${Strs.supplierReqStr.tr}: "),
            CupertinoButton(
              child: Text(
                Strs.selectPleaseStr.tr,
                style: TextStyle(
                    fontFamily: Get.theme.textTheme.button!.fontFamily),
              ),
              onPressed: () {
                showBarModalBottomSheet(
                    shape: const SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius.vertical(
                        top: SmoothRadius(
                          cornerRadius: 40,
                          cornerSmoothing: 1,
                        ),
                      ),
                    ),
                    context: Get.context!,
                    builder: (context) {
                      return UserPicker(
                        onUserPicked: (user) {
                          exchangeRequest.supplierNationalId = user.key;
                          exchangeRequest.supplierName = (user.value)["name"];
                          Get.back();
                        },
                      );
                    });
              },
            ),
          ],
        ),
        Obx(
          () {
            return Visibility(
              visible: exchangeRequest.supplierNationalId != null,
              child: getSupplierContent(),
            );
          },
        ),
      ],
    );
  }

  Card getSupplierContent() {
    return Card(
      shape: SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: 15,
          cornerSmoothing: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "${exchangeRequest.supplierName}",
              style: Get.theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget getChangerSignatureWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text("${Strs.changerSignatureStr.tr}: "),
            CupertinoButton(
              child: Text(
                Strs.signStr.tr,
                style: TextStyle(
                    fontFamily: Get.theme.textTheme.button!.fontFamily),
              ),
              onPressed: () {
                final GlobalKey<SfSignaturePadState> signatureKey = GlobalKey();
                showFloatingModalBottomSheet(
                  context: Get.context!,
                  builder: (context) {
                    return Signature(
                      signatureKey: signatureKey,
                      onSavePressed: () async {
                        if (signatureKey.currentState!.toPathList().isEmpty) {
                          exchangeRequest.changerSignature = null;
                          Get.back();
                          return;
                        }
                        final signatureUint8List = (await (await signatureKey
                                    .currentState!
                                    .toImage(pixelRatio: 3.0))
                                .toByteData(format: ImageByteFormat.png))
                            ?.buffer
                            .asUint8List();
                        exchangeRequest.changerSignature = signatureUint8List;
                        Get.back();
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
        Obx(
          () {
            return Visibility(
              visible: exchangeRequest.changerSignature != null,
              child: getSignatureContent(exchangeRequest.changerSignature),
            );
          },
        ),
      ],
    );
  }

  Widget getSignatureContent(Uint8List? pngBytes) {
    if (pngBytes == null) return Container();
    return Center(
      child: Image.memory(
        pngBytes,
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
        height: 150,
        width: 150,
      ),
    );
  }

  void _onSendButtonPressed(RxBool isShowButtonIndicator) {
    if (isShowButtonIndicator.value) return;
    isShowButtonIndicator.value = true;
    if (exchangeRequest.changerNationalId == null ||
        exchangeRequest.changerName == null ||
        exchangeRequest.changerShiftDate == null ||
        exchangeRequest.changerShiftDescription == null ||
        exchangeRequest.supplierNationalId == null ||
        exchangeRequest.supplierName == null ||
        exchangeRequest.changerSignature == null) {
      showSnackbar(
        Strs.fillExchangeReqFormWarningMessage.tr,
        messageType: MessageType.error,
      );
      isShowButtonIndicator.value = false;
    } else {
      PdfService.createExchangeReqPdf(exchangeRequest)
          .then((value) => isShowButtonIndicator.value = false);
    }
  }

  Widget getSendButton() {
    final isShowButtonIndicator = false.obs;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ClipSmoothRect(
        radius: SmoothBorderRadius(
          cornerRadius: 15,
          cornerSmoothing: 1,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: CupertinoButton.filled(
            onPressed: () => _onSendButtonPressed(isShowButtonIndicator),
            child: Obx(
              () => !isShowButtonIndicator.value
                  ? Text(
                      Strs.sendStr.tr,
                      style: TextStyle(
                          fontFamily: Get.theme.textTheme.button!.fontFamily),
                    )
                  : FittedBox(
                      fit: BoxFit.scaleDown,
                      child: CircularProgressIndicator(
                          color: Get.theme.colorScheme.onPrimary),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
