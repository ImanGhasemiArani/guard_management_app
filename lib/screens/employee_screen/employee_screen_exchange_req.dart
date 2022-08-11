import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../lang/strs.dart';
import '../../model/exchange_request.dart';
import '../../services/server_service.dart';
import 'employee_shift_picker.dart';

ExchangeRequest exchangeRequest = ExchangeRequest(currentUser.nationalId!);

class ScreenExchangeReq extends StatelessWidget {
  const ScreenExchangeReq({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    exchangeRequest = ExchangeRequest(currentUser.nationalId!);
    return Scaffold(
      appBar: getAppBar(),
      body: getBody(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      title: Text(Strs.exchangeReqFormStr.tr),
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: GestureDetector(
        onTap: Get.back,
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(15),
          child: const Icon(
            CupertinoIcons.chevron_back,
          ),
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
        Text(currentUser.name!),
        Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text("${Strs.changerShiftStr.tr}: "),
            CupertinoButton(
              child: Text(
                Strs.selectStr.tr,
                style: TextStyle(
                    fontFamily: Get.theme.textTheme.button!.fontFamily),
              ),
              onPressed: () {
                Get.to(
                  ShiftPicker(
                    onShiftPicked: (shift) {
                      var f = Jalali.fromDateTime(shift.key).formatter;
                      exchangeRequest.changerShiftDate =
                          "${f.d}  ${f.mN}  ${f.y}";
                      exchangeRequest.changerShiftDescription =
                          shift.value['shift'];
                      Get.back();
                    },
                  ),
                  transition: Transition.rightToLeftWithFade,
                );
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
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
}
