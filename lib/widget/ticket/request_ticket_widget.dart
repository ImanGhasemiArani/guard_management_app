import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../lang/strs.dart';
import '../../model/exchange_request.dart';
import '../../services/server_service.dart';
import '../bottom_sheet_modal/floating_modal.dart';
import '../signature/signature.dart';

typedef FooterBuilder = Widget Function(
    void Function() switchExpand, bool isExpanded);
bool isShowButton = false;

// ignore: must_be_immutable
class RequestTicketWidget extends StatelessWidget {
  RequestTicketWidget({
    super.key,
    ExchangeRequest? request,
    this.collapsed,
    this.expanded,
    this.footer,
    this.collapsedHeight,
    this.expandedHeight,
    this.isShowButton = false,
  }) {
    if (request != null) {
      _request = request.obs;
      _buildContents(request);
    } else {
      _request = null.obs;
    }
  }

  late final Rx<ExchangeRequest?> _request;
  Widget? collapsed;
  Widget? expanded;
  FooterBuilder? footer;
  double? collapsedHeight;
  double? expandedHeight;
  bool isShowButton;

  @override
  Widget build(BuildContext context) {
    final isExpanded = false.obs;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutQuart,
                height: isExpanded.value
                    ? expandedHeight! + collapsedHeight!
                    : collapsedHeight,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Obx(
                    () {
                      _buildContents(_request.value!);
                      return Column(
                        children: [
                          SizedBox(
                            height: collapsedHeight,
                            width: double.infinity,
                            child: collapsed,
                          ),
                          SizedBox(
                            height: expandedHeight,
                            width: double.infinity,
                            child: expanded,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              footer!(
                () => isExpanded.value = !isExpanded.value,
                isExpanded.value,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _buildContents(ExchangeRequest request) {
    collapsedHeight = isShowButton ? 180 : 120;
    expandedHeight = 300;
    collapsed = _buildCollapsedContent(request);
    expanded = _buildExpandedContent(request);
    footer = _buildFooterContent;
  }

  Widget _buildCollapsedContent(ExchangeRequest request) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${Strs.requestStatusStr.tr}: ",
                  style: TextStyle(
                    fontFamily: Get.theme.textTheme.overline?.fontFamily,
                    fontStyle: Get.theme.textTheme.overline?.fontStyle,
                    fontSize: Get.theme.textTheme.overline?.fontSize,
                    fontWeight: Get.theme.textTheme.overline?.fontWeight,
                    letterSpacing: Get.theme.textTheme.overline?.letterSpacing,
                  ),
                ),
                Text(
                  "${request.reqStatus}",
                  style: TextStyle(
                    color: request.status!.name.contains("W")
                        ? Colors.amber
                        : request.status!.name.contains("F")
                            ? Colors.red
                            : Colors.green,
                    fontFamily: Get.theme.textTheme.subtitle2?.fontFamily,
                    fontStyle: Get.theme.textTheme.subtitle2?.fontStyle,
                    fontSize: Get.theme.textTheme.subtitle2?.fontSize,
                    fontWeight: Get.theme.textTheme.subtitle2?.fontWeight,
                    letterSpacing: Get.theme.textTheme.subtitle2?.letterSpacing,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${Strs.changerReqStr.tr}: ",
                  style: TextStyle(
                    fontFamily: Get.theme.textTheme.overline?.fontFamily,
                    fontStyle: Get.theme.textTheme.overline?.fontStyle,
                    fontSize: Get.theme.textTheme.overline?.fontSize,
                    fontWeight: Get.theme.textTheme.overline?.fontWeight,
                    letterSpacing: Get.theme.textTheme.overline?.letterSpacing,
                  ),
                ),
                Text(
                  "${request.changerName}",
                  style: TextStyle(
                    fontFamily: Get.theme.textTheme.subtitle2?.fontFamily,
                    fontStyle: Get.theme.textTheme.subtitle2?.fontStyle,
                    fontSize: Get.theme.textTheme.subtitle2?.fontSize,
                    fontWeight: Get.theme.textTheme.subtitle2?.fontWeight,
                    letterSpacing: Get.theme.textTheme.subtitle2?.letterSpacing,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${Strs.supplierReqStr.tr}: ",
                    style: TextStyle(
                      fontFamily: Get.theme.textTheme.overline?.fontFamily,
                      fontStyle: Get.theme.textTheme.overline?.fontStyle,
                      fontSize: Get.theme.textTheme.overline?.fontSize,
                      fontWeight: Get.theme.textTheme.overline?.fontWeight,
                      letterSpacing:
                          Get.theme.textTheme.overline?.letterSpacing,
                    ),
                  ),
                  Text(
                    "${request.supplierName}",
                    style: TextStyle(
                      fontFamily: Get.theme.textTheme.subtitle2?.fontFamily,
                      fontStyle: Get.theme.textTheme.subtitle2?.fontStyle,
                      fontSize: Get.theme.textTheme.subtitle2?.fontSize,
                      fontWeight: Get.theme.textTheme.subtitle2?.fontWeight,
                      letterSpacing:
                          Get.theme.textTheme.subtitle2?.letterSpacing,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${Strs.exchangeReqShiftStr.tr}: ",
                  style: TextStyle(
                    fontFamily: Get.theme.textTheme.overline?.fontFamily,
                    fontStyle: Get.theme.textTheme.overline?.fontStyle,
                    fontSize: Get.theme.textTheme.overline?.fontSize,
                    fontWeight: Get.theme.textTheme.overline?.fontWeight,
                    letterSpacing: Get.theme.textTheme.overline?.letterSpacing,
                  ),
                ),
                Text(
                  "${request.changerShiftDateString}",
                  style: TextStyle(
                    fontFamily: Get.theme.textTheme.subtitle1?.fontFamily,
                    fontStyle: Get.theme.textTheme.subtitle1?.fontStyle,
                    fontSize: Get.theme.textTheme.subtitle1?.fontSize,
                    fontWeight: Get.theme.textTheme.subtitle1?.fontWeight,
                    letterSpacing: Get.theme.textTheme.subtitle1?.letterSpacing,
                  ),
                ),
                Text(
                  " - ${request.changerShiftDescriptionString}",
                  style: TextStyle(
                    fontFamily: Get.theme.textTheme.subtitle2?.fontFamily,
                    fontStyle: Get.theme.textTheme.subtitle2?.fontStyle,
                    fontSize: Get.theme.textTheme.subtitle2?.fontSize,
                    fontWeight: Get.theme.textTheme.subtitle2?.fontWeight,
                    letterSpacing: Get.theme.textTheme.subtitle2?.letterSpacing,
                  ),
                ),
              ],
            ),
          ),
          if (isShowButton)
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_request.value!.status!.name.contains("S"))
                    CupertinoButton.filled(
                      borderRadius: BorderRadius.circular(100),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      minSize: 0,
                      child: Text(
                        Strs.confirmStr.tr,
                        style: TextStyle(
                          fontFamily: Get.theme.textTheme.overline?.fontFamily,
                          fontStyle: Get.theme.textTheme.overline?.fontStyle,
                          fontSize: Get.theme.textTheme.overline?.fontSize,
                          fontWeight: Get.theme.textTheme.overline?.fontWeight,
                          letterSpacing:
                              Get.theme.textTheme.overline?.letterSpacing,
                        ),
                      ),
                      onPressed: () {
                        final GlobalKey<SfSignaturePadState> signatureKey =
                            GlobalKey();
                        showFloatingModalBottomSheet(
                          context: Get.context!,
                          builder: (context) {
                            return Signature(
                              signatureKey: signatureKey,
                              onSavePressed: () async {
                                if (signatureKey.currentState!
                                    .toPathList()
                                    .isEmpty) {
                                  request.supplierSignature = null;
                                  Get.back();
                                  return;
                                }
                                final signatureUint8List =
                                    (await (await signatureKey.currentState!
                                                .toImage(pixelRatio: 3.0))
                                            .toByteData(
                                                format: ImageByteFormat.png))
                                        ?.buffer
                                        .asUint8List();
                                request.supplierSignature = signatureUint8List;

                                Get.back();
                              },
                            );
                          },
                        ).then((value) {
                          if (request.supplierSignature != null) {
                            ServerService.changeExReqStatus(
                                    username:
                                        ServerService.currentUser.username!,
                                    req: request,
                                    status: ExchangeRequestStatus.WH)
                                .then((value) => _request.value = value);
                          }
                        });
                      },
                    ),
                  if (_request.value!.status!.name.contains("H"))
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      minSize: 0,
                      child: Text(
                        Strs.rejectStr.tr,
                        style: TextStyle(
                          fontFamily: Get.theme.textTheme.overline?.fontFamily,
                          fontStyle: Get.theme.textTheme.overline?.fontStyle,
                          fontSize: Get.theme.textTheme.overline?.fontSize,
                          fontWeight: Get.theme.textTheme.overline?.fontWeight,
                          letterSpacing:
                              Get.theme.textTheme.overline?.letterSpacing,
                        ),
                      ),
                      onPressed: () {
                        ServerService.changeExReqStatus(
                                username: ServerService.currentUser.username!,
                                req: request,
                                status: ExchangeRequestStatus.FS)
                            .then((value) => _request.value = value);
                      },
                    ),
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _buildExpandedContent(ExchangeRequest request) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "${Strs.changerConfirmStr.tr}: \n ${request.changerConfirmDate}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: Get.theme.textTheme.overline?.fontFamily,
                  fontStyle: Get.theme.textTheme.overline?.fontStyle,
                  fontSize: Get.theme.textTheme.overline?.fontSize,
                  fontWeight: Get.theme.textTheme.overline?.fontWeight,
                  letterSpacing: Get.theme.textTheme.overline?.letterSpacing,
                ),
              ),
              if (request.changerSignature != null)
                Image.memory(
                  request.changerSignature!,
                  height: 100,
                  width: 100,
                ),
              if (request.changerSignature == null)
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Center(child: Text(Strs.notConfirmedStr.tr)),
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "${Strs.supplierConfirmStr.tr}: \n ${request.supplierConfirmDate}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: Get.theme.textTheme.overline?.fontFamily,
                  fontStyle: Get.theme.textTheme.overline?.fontStyle,
                  fontSize: Get.theme.textTheme.overline?.fontSize,
                  fontWeight: Get.theme.textTheme.overline?.fontWeight,
                  letterSpacing: Get.theme.textTheme.overline?.letterSpacing,
                ),
              ),
              if (request.supplierSignature != null)
                Image.memory(
                  request.supplierSignature!,
                  height: 100,
                  width: 100,
                ),
              if (request.supplierSignature == null)
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Center(child: Text(Strs.notConfirmedStr.tr)),
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "${Strs.headerConfirmStr.tr}: \n ${request.headUserConfirmDate}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: Get.theme.textTheme.overline?.fontFamily,
                  fontStyle: Get.theme.textTheme.overline?.fontStyle,
                  fontSize: Get.theme.textTheme.overline?.fontSize,
                  fontWeight: Get.theme.textTheme.overline?.fontWeight,
                  letterSpacing: Get.theme.textTheme.overline?.letterSpacing,
                ),
              ),
              if (request.headUserSignature != null)
                Image.memory(
                  request.headUserSignature!,
                  height: 100,
                  width: 100,
                ),
              if (request.headUserSignature == null)
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Center(child: Text(Strs.notConfirmedStr.tr)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterContent(void Function() switchExpand, bool isExpanded) {
    return CupertinoButton(
      padding: const EdgeInsets.all(5),
      minSize: 0,
      onPressed: switchExpand,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          Text(
            Strs.confirmationsStr.tr,
            style: TextStyle(
              fontFamily: Get.theme.textTheme.overline?.fontFamily,
              fontSize: Get.theme.textTheme.overline?.fontSize,
              height: Get.theme.textTheme.overline?.height,
              fontStyle: Get.theme.textTheme.overline?.fontStyle,
              fontWeight: Get.theme.textTheme.overline?.fontWeight,
              letterSpacing: Get.theme.textTheme.overline?.letterSpacing,
            ),
          ),
          Icon(
            isExpanded
                ? CupertinoIcons.chevron_up
                : CupertinoIcons.chevron_down,
            size: 18,
          ),
        ],
      ),
    );
  }
}
