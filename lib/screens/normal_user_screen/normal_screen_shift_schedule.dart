import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../lang/strs.dart';
import '../../services/server_service.dart';
import '../../utils/data_utils.dart';
import '../../widget/appbar/my_appbar.dart';
import 'normal_shift_picker.dart';

class ScreenShiftSchedule extends StatelessWidget {
  const ScreenShiftSchedule({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTableView = false.obs;
    return Scaffold(
      appBar: getAppBar(isTableView),
      body: Obx(() => isTableView.value
          ? const ShiftTableView()
          : const ShiftCalendarView()),
    );
  }

  PreferredSizeWidget getAppBar(RxBool isTableView) => MyAppBar(
        backgroundColor: Get.theme.colorScheme.background,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(Strs.shiftScheduleStr.tr),
        ),
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
        actions: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              isTableView.value = !isTableView.value;
            },
            child: Card(
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 10,
                  cornerSmoothing: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.calendar,
                      size: 20,
                      color: Get.theme.colorScheme.secondary,
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      CupertinoIcons.arrow_right_arrow_left,
                      size: 15,
                      color: Get.theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      CupertinoIcons.table,
                      size: 20,
                      color: Get.theme.colorScheme.secondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}

class ShiftTableView extends StatelessWidget {
  const ShiftTableView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('ShiftTableView');
  }
}

class ShiftCalendarView extends StatelessWidget {
  const ShiftCalendarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShiftPicker(
      isShowAppBar: false,
      isShowMarkCalendar: false,
      isShowExchangeableBanner: false,
      future: Future.sync(
        () async {
          final f = Jalali.now().formatter;
          return DataUtils.sortByCurrentUser(
            await ServerService.getAllUserSchedule(
              isFilterDate: true,
              afterDate: "${f.y}-${f.m}-${f.d}",
            ),
          );
        },
      ),
    );
  }
}
