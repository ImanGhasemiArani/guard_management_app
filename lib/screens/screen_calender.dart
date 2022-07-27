import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:guard_management_app/services/server_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../lang/strs.dart';
import '../widget/calendar/calendar.dart';
import '../widget/calendar/classes/persian_date.dart';

Rx<DateTime> currentSelectedDate =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).obs;

class ScreenCalender extends StatelessWidget {
  const ScreenCalender({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var allEvents = snapshot.data as Map<DateTime, List<dynamic>>;
            var currentUserEvents = _getCurrentUserEvents(allEvents);
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: SafeArea(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 25),
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.5 + 20,
                          ),
                          child: CalendarContent(events: currentUserEvents),
                        ),
                        EventContent(events: allEvents),
                      ],
                    ),
                  ),
                ),
              ),
            );
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
    var rawData = await getAllPlanFromServer();
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
    var userId = currentUser.objectId!;
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

class EventContent extends StatelessWidget {
  const EventContent({
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
                          : EventListChild(
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
    print(currentDate.weekDay);
    String title =
        "${isToday ? ' امروز' : ''} ${dayLong[currentDate.weekDay - 1]}  ${currentDate.day}  ${monthLong[currentDate.month - 1]}  ${currentDate.year}";
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 50,
      color: Get.theme.colorScheme.background,
      alignment: Alignment.centerRight,
      child: Text(
        "برنامه کاری$title",
        style: Get.theme.textTheme.subtitle1,
      ),
    );
  }

  List<dynamic> _getSortedEvents(List<dynamic> allEvents) {
    var userId = currentUser.objectId!;
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

class EventListChild extends StatelessWidget {
  const EventListChild({
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
            child: Text(Strs.requestExChangePlanStr.tr,
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
              Divider(),
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
  }) : super(key: key);

  final Map<DateTime, List<dynamic>>? events;

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
        onDaySelected: (day) => currentSelectedDate.value = day,
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
