import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../lang/strs.dart';
import '../../services/server_service.dart';
import '../../widget/calendar/shamsi_table_calendar.dart';
import '../../widget/staggered_animations/flutter_staggered_animations.dart';

Rx<DateTime> currentSelectedDate =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).obs;

// ignore: must_be_immutable
class ScreenCalender extends HookWidget {
  ScreenCalender({
    Key? key,
  }) : super(key: key);

  late ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    _scrollController = useScrollController();
    return FutureBuilder(
        future: getEvents(),
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
                var allEvents = snapshot.data as Map<DateTime, List<dynamic>>;
                var currentUserEvents = _getCurrentUserEvents(allEvents);
                RxInt segmentController = 0.obs;
                return Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  body: SafeArea(
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 25),
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: NestedScrollView(
                          controller: _scrollController,
                          headerSliverBuilder: (context, innerBoxIsScrolled) =>
                              [
                            SliverAppBar(
                              floating: false,
                              forceElevated: innerBoxIsScrolled,
                              backgroundColor: Colors.transparent,
                              collapsedHeight: 400 < Get.size.height * 0.5 + 20
                                  ? 400
                                  : Get.size.height * 0.5 + 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              flexibleSpace: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxHeight: Get.size.height * 0.5 + 20,
                                      maxWidth: 600),
                                  child: CalendarContent(
                                    events: currentUserEvents,
                                    scrollController: _scrollController,
                                    segmentController: segmentController,
                                  ),
                                ),
                              ),
                            ),
                            SliverAppBar(
                              pinned: true,
                              forceElevated: true,
                              backgroundColor: Get.theme.colorScheme.background,
                              centerTitle: true,
                              surfaceTintColor:
                                  Get.theme.colorScheme.background,
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
                                    ? PlanEventContent(
                                        events: allEvents,
                                      )
                                    : const DayEventContent(),
                              ),
                            ],
                          ),
                        ),
                      ),
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
            return Center(
              child: LoadingAnimationWidget.dotsTriangle(
                color: const Color(0xfff5d042),
                size: 40,
              ),
            );
          }
        });
  }

  Future<Map<DateTime, List<dynamic>>> getEvents() async {
    currentSelectedDate.value =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var rawData = await ServerService.getAllPlanFromServer();
    var events = <DateTime, List<dynamic>>{};
    for (var row in rawData) {
      var plans = row["plan"] as List<dynamic>;
      for (var plan in plans) {
        var event = plan as Map<String, dynamic>;
        var data = event.keys.first.split("-");
        var dateTime =
            Jalali(int.parse(data[0]), int.parse(data[1]), int.parse(data[2]))
                .toGregorian()
                .toDateTime();
        if (events[dateTime] == null) {
          events[dateTime] = [];
        }

        events[dateTime]!.add({
          "name": row["name"],
          "userId": row["userId"],
          "event": event.values.first
        });
      }
    }
    return events;
  }

  Map<DateTime, List<dynamic>> _getCurrentUserEvents(
      Map<DateTime, List> allEvents) {
    var userId = ServerService.currentParseUser.objectId!;
    var currentUserEvents = <DateTime, List<dynamic>>{};
    allEvents.forEach((dateTime, events) {
      var userEvents = events.where((event) {
        return event["userId"] == userId;
      }).toList();
      if (userEvents.isNotEmpty) {
        currentUserEvents[dateTime] = userEvents;
      }
    });
    return currentUserEvents;
  }
}

class DayEventContent extends StatelessWidget {
  const DayEventContent({
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
              return Expanded(
                child: Center(
                  child: LoadingAnimationWidget.dotsTriangle(
                    color: const Color(0xfff5d042),
                    size: 40,
                  ),
                ),
              );
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
        "${isToday ? ' ${Strs.todayStr.tr}' : ''} ${dayFull[currentDate.weekDay - 1]}  ${currentDate.day}  ${monthFull[currentDate.month - 1]}  ${currentDate.year} ${isHoliday ? '- ${Strs.holidayStr.tr}' : ''}";
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

class PlanEventContent extends StatelessWidget {
  const PlanEventContent({
    Key? key,
    required this.events,
  }) : super(key: key);

  final Map<DateTime, List> events;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        var newEvents = events[currentSelectedDate.value] ?? [];
        newEvents = _getSortedEvents(newEvents);
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
                          : PlanEventListChild(
                              newEvents: newEvents, index: index - 1),
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
        "${isToday ? ' ${Strs.todayStr.tr}' : ''} ${dayFull[currentDate.weekDay - 1]}  ${currentDate.day}  ${monthFull[currentDate.month - 1]}  ${currentDate.year}";
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

  List<dynamic> _getSortedEvents(List<dynamic> allEvents) {
    var userId = ServerService.currentParseUser.objectId!;
    var currentUserEvents = List<dynamic>.from(allEvents);
    currentUserEvents.sort((a, b) {
      if (a["userId"] == userId) {
        return -1;
      } else if (b["userId"] == userId) {
        return 1;
      } else {
        return 0;
      }
    });
    return currentUserEvents;
  }
}

class PlanEventListChild extends StatelessWidget {
  const PlanEventListChild({
    Key? key,
    required this.newEvents,
    required this.index,
  }) : super(key: key);

  final List newEvents;
  final int index;

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
            onPressed: () {},
            padding: EdgeInsets.zero,
            child: Text(Strs.exchangeReqStr.tr,
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
                newEvents[index]["event"],
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
      child: ShamsiTableCalendar(
        events: events,
        onDaySelected: (day) {
          scrollController.animateTo(0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn);
          segmentController.value = 0;
          currentSelectedDate.value = day.toDateTime();
        },
        eventMarkerBuilder: (date, events) {
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
