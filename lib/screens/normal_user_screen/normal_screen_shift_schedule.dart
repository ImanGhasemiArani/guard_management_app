import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../assets/assets.gen.dart';
import '../../lang/strs.dart';
import '../../services/server_service.dart';
import '../../utils/data_utils.dart';
import '../../widget/appbar/my_appbar.dart';
import '../../widget/future_builder/custom_future_builder.dart';
import '../../widget/shift_schedule_table_view/shift_schedule_table_view.dart';
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
      body: CustomFutureBuilder(
        future: Future.sync(
          () async {
            final f = Jalali.now().formatter;
            return DataUtils.sortByTeam(
              await ServerService.getAllUserSchedule(
                isFilterDate: true,
                afterDate: "${f.y}-${f.m}-${f.d}",
              ),
            );
          },
        ),
        builder: (context, data) => Obx(
          () => isTableView.value
              ? ShiftScheduleTableView(
                  future: Future.sync(() => data),
                )
              : ShiftCalendarView(data: data as List<Map<String, dynamic>>),
        ),
      ),
    );
  }

  PreferredSizeWidget getAppBar(RxBool isTableView) => MyAppBar(
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
            child: Assets.icons.arrowLeft3.svg(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CupertinoButton(
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
                      Assets.icons.calendar.svg(size: 20),
                      const SizedBox(width: 5),
                      Assets.icons.arrowSwapHorizontal.svg(size: 15),
                      const SizedBox(width: 5),
                      Assets.icons.grid1.svg(size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}

class ShiftCalendarView extends StatelessWidget {
  const ShiftCalendarView({
    Key? key,
    required this.data,
  }) : super(key: key);

  final List<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    return ShiftPicker(
      isShowAppBar: false,
      isShowExchangeableBanner: false,
      future: Future.sync(
        () {
          return DataUtils.sortByCurrentUser(data);
        },
      ),
    );
  }
}
