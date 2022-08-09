import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../lang/strs.dart';
import '../../model/exchange_request.dart';
import '../../services/server_service.dart';
import 'employee_screen_calender.dart';

ExchangeRequest? exchangeRequest;

class ScreenExchangeReq extends StatelessWidget {
  const ScreenExchangeReq({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    exchangeRequest =
        ExchangeRequest(changerNationalId: currentUser.nationalId!);
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: SingleChildScrollView(
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
      ),
    );
  }

  Widget getChangerReqWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strs.changerReqStr.tr),
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
                  ScreenCalender(),
                  transition: Transition.rightToLeftWithFade,
                );
              },
            ),
            Visibility(
                visible: exchangeRequest!.changerShiftDate != null,
                child: Text(exchangeRequest!.changerShiftDate ?? "")),
          ],
        )
      ],
    );
  }
}
