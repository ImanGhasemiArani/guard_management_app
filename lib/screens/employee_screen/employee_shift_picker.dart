import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../lang/strs.dart';
import '../../services/server_service.dart';
import '../../utils/data_utils.dart';
import '../../widget/calendar/calendar.dart';
import '../../widget/calendar/src/persian_date.dart';
import '../../widget/loading_widget/loading_widget.dart';
import '../../widget/staggered_animations/flutter_staggered_animations.dart';

typedef OnShiftPicked = void Function(
    MapEntry<DateTime, Map<String, dynamic>> shift);

Rx<DateTime> currentSelectedDate =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).obs;

// ignore: must_be_immutable
class ShiftPicker extends HookWidget {
  ShiftPicker({
    Key? key,
    this.onShiftPicked,
  }) : super(key: key);

  late ScrollController _scrollController;
  final OnShiftPicked? onShiftPicked;

  @override
  Widget build(BuildContext context) {
    currentSelectedDate.value =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    _scrollController = useScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Strs.selectShiftStr.tr,
          style: Get.theme.textTheme.bodyLarge,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ScaffoldBody(
        scrollController: _scrollController,
        onShiftPicked: onShiftPicked,
      ),
    );
  }
}

class ScaffoldBody extends StatelessWidget {
  const ScaffoldBody({
    Key? key,
    required this.scrollController,
    this.onShiftPicked,
  }) : super(key: key);

  final ScrollController scrollController;
  final OnShiftPicked? onShiftPicked;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ServerService.getSpecificUserPlan(
        username: ServerService.currentUser.nationalId!,
        isFilterMPlans: true,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          try {
            if (!snapshot.hasData || snapshot.data == null) throw Exception();
            var events = DataUtils.convertPlanToEvents(
                [snapshot.data as Map<String, dynamic>]);
            RxInt segmentController = 0.obs;
            return SafeArea(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: NestedScrollView(
                    controller: scrollController,
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        floating: false,
                        forceElevated: innerBoxIsScrolled,
                        scrolledUnderElevation: 0,
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        collapsedHeight: 400 < Get.size.height * 0.5 + 20
                            ? 400
                            : Get.size.height * 0.5 + 20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        flexibleSpace: SingleChildScrollView(
                          //   physics: const NeverScrollableScrollPhysics(),
                          child: Container(
                            constraints: const BoxConstraints(
                                // maxHeight: Get.size.height * 0.5 + 20,
                                maxWidth: 600),
                            child: CalendarContent(
                              events: events,
                              scrollController: scrollController,
                              segmentController: segmentController,
                            ),
                          ),
                        ),
                      ),
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        pinned: true,
                        forceElevated: true,
                        centerTitle: true,
                        scrolledUnderElevation: 0,
                        elevation: 0,
                        backgroundColor: Get.theme.colorScheme.background,
                        title: Obx(
                          () => CupertinoSlidingSegmentedControl<int>(
                            groupValue: segmentController.value,
                            children: {
                              1: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  Strs.eventDayContentTitleStr.tr,
                                  style: Get.theme.textTheme.subtitle2,
                                ),
                              ),
                              0: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  Strs.workingPlanTitleStr.tr,
                                  style: Get.theme.textTheme.subtitle2,
                                ),
                              ),
                            },
                            onValueChanged: (index) {
                              segmentController.value = index ?? 0;
                            },
                          ),
                        ),
                      )
                    ],
                    body: Column(
                      children: [
                        Obx(
                          () => segmentController.value == 0
                              ? ShiftsListView(
                                  events: events,
                                  onShiftPicked: onShiftPicked,
                                )
                              : const DayEventsListView(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } catch (e) {
            return Center(
              child: Text(
                "${Strs.failedToLoadDataFromServerErrorMessage.tr}\n${Strs.tryAgainErrorMessage.tr}",
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: Get.theme.textTheme.subtitle2,
              ),
            );
          }
        } else {
          return const LoadingWidget();
        }
      },
    );
  }
}

class DayEventsListView extends StatelessWidget {
  const DayEventsListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return FutureBuilder(
          future: ServerService.getDayEvents(currentSelectedDate.value),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null || !snapshot.hasData) {
                return Center(
                  child: Text(
                    Strs.failedToLoadErrorStr.tr,
                    style: Get.theme.textTheme.subtitle2,
                  ),
                );
              } else {
                try {
                  var dayMap = snapshot.data as Map<String, dynamic>;
                  var events = dayMap['events'] as List<dynamic>;
                  return Expanded(
                    child: AnimationLimiter(
                      key: UniqueKey(),
                      child: ListView.builder(
                        itemCount: events.length + 1,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              verticalOffset: 50,
                              child: FadeInAnimation(
                                child: index == 0
                                    ? _getFirstContent(
                                        dayMap['is_holiday'] ?? false)
                                    : _getEventChild(events, index - 1),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } catch (e) {
                  return Center(
                    child: Text(
                      Strs.failedToLoadErrorStr.tr,
                      style: Get.theme.textTheme.subtitle2,
                    ),
                  );
                }
              }
            } else {
              return const Expanded(child: LoadingWidget());
            }
          },
        );
      },
    );
  }

  Container _getFirstContent(bool isHoliday) {
    var currentDate = Jalali.fromDateTime(currentSelectedDate.value);
    var nowTime = DateTime.now();
    bool isToday = currentSelectedDate.value.year == nowTime.year &&
        currentSelectedDate.value.month == nowTime.month &&
        currentSelectedDate.value.day == nowTime.day;
    String title =
        "${isToday ? ' ${Strs.todayStr.tr}' : ''} ${dayLong[currentDate.weekDay - 1]}  ${currentDate.day}  ${monthLong[currentDate.month - 1]}  ${currentDate.year} ${isHoliday ? '- ${Strs.holidayStr.tr}' : ''}";
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 50,
      color: Get.theme.colorScheme.background,
      alignment: Alignment.centerRight,
      child: Text(
        "${Strs.eventsDayStr.tr}$title",
        style: Get.theme.textTheme.subtitle1,
      ),
    );
  }

  Container _getEventChild(List<dynamic> events, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      alignment: Alignment.centerRight,
      child: Text(
        events[index]['description'],
        style: Get.theme.textTheme.subtitle1,
        textDirection: TextDirection.rtl,
      ),
    );
  }
}

class ShiftsListView extends StatelessWidget {
  const ShiftsListView({
    Key? key,
    required this.events,
    this.onShiftPicked,
  }) : super(key: key);

  final Map<DateTime, List> events;
  final OnShiftPicked? onShiftPicked;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        var newEvents = events[currentSelectedDate.value] ?? [];
        return Expanded(
          child: AnimationLimiter(
            key: UniqueKey(),
            child: ListView.builder(
              itemCount: newEvents.length + 1,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    verticalOffset: 50,
                    child: FadeInAnimation(
                      child: index == 0
                          ? _getFirstContent()
                          : ShiftsListTile(
                              newEvents: newEvents,
                              index: index - 1,
                              onShiftPicked: onShiftPicked,
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Container _getFirstContent() {
    var currentDate = Jalali.fromDateTime(currentSelectedDate.value);
    var nowTime = DateTime.now();
    bool isToday = currentSelectedDate.value.year == nowTime.year &&
        currentSelectedDate.value.month == nowTime.month &&
        currentSelectedDate.value.day == nowTime.day;
    String title =
        "${isToday ? ' ${Strs.todayStr.tr}' : ''} ${dayLong[currentDate.weekDay - 1]}  ${currentDate.day}  ${monthLong[currentDate.month - 1]}  ${currentDate.year}";
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 50,
      color: Get.theme.colorScheme.background,
      alignment: Alignment.centerRight,
      child: Text(
        "${Strs.workingPlanStr.tr}$title",
        style: Get.theme.textTheme.subtitle1,
      ),
    );
  }
}

class ShiftsListTile extends StatelessWidget {
  const ShiftsListTile({
    Key? key,
    required this.newEvents,
    required this.index,
    this.onShiftPicked,
  }) : super(key: key);

  final List newEvents;
  final int index;
  final OnShiftPicked? onShiftPicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CupertinoButton(
            onPressed: () {
              onShiftPicked
                  ?.call(MapEntry(currentSelectedDate.value, newEvents[index]));
            },
            padding: EdgeInsets.zero,
            child: Text(Strs.selectStr.tr,
                style: Get.theme.textTheme.subtitle2!.copyWith(
                  color: Get.theme.colorScheme.primary,
                )),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                newEvents[index]["name"],
                style: Get.theme.textTheme.subtitle1,
              ),
              Text(
                newEvents[index]["shift"],
                style: Get.theme.textTheme.bodyText2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CalendarContent extends StatelessWidget {
  const CalendarContent({
    Key? key,
    required this.events,
    required this.scrollController,
    required this.segmentController,
  }) : super(key: key);

  final Map<DateTime, List<dynamic>>? events;
  final ScrollController scrollController;
  final RxInt segmentController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: JalaliTableCalendar(
        context: context,
        events: events,
        onDaySelected: (day) {
          scrollController.animateTo(0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn);
          segmentController.value = 0;
          currentSelectedDate.value = day;
        },
        marker: (date, events) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Get.theme.colorScheme.primary.withOpacity(0.5),
              ),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(6.0),
          );
        },
      ),
    );
  }
}
