import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guard_management_app/services/server_service.dart';
import 'package:guard_management_app/widget/staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../lang/strs.dart';
import '../widget/calendar/src/persian_date.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getEventsForHomeScreen(),
      builder: ((context, snapshot) {
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
              return HomeScreenListContent(
                  events:
                      snapshot.data as List<MapEntry<DateTime, List<dynamic>>>);
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
      }),
    );
  }

  Future<List<MapEntry<DateTime, List<dynamic>>>>
      _getEventsForHomeScreen() async {
    var allEvents = await _getEvents();
    allEvents
        .sort((mapEntry1, mapEntry2) => mapEntry1.key.compareTo(mapEntry2.key));
    var now = DateTime.now();
    var comparativeNow = DateTime(now.year, now.month, now.day);
    int indexNow = allEvents.indexWhere((mapEntry) =>
        mapEntry.key.isAtSameMomentAs(comparativeNow) ||
        mapEntry.key.isAfter(comparativeNow));
    var events = <MapEntry<DateTime, List<dynamic>>>[];
    if (indexNow != -1) {
      if (allEvents[indexNow].key.isAtSameMomentAs(comparativeNow)) {
        events = allEvents.sublist(indexNow, indexNow + 4);
      } else {
        events = allEvents.sublist(indexNow, indexNow + 3);
      }
    }
    return events;
  }

  Future<List<MapEntry<DateTime, List<dynamic>>>> _getEvents() async {
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
    var currentUserEvents = _getCurrentUserEvents(events);
    return currentUserEvents.entries.toList();
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

class HomeScreenListContent extends StatelessWidget {
  const HomeScreenListContent({
    Key? key,
    required this.events,
  }) : super(key: key);
  final List<MapEntry<DateTime, List<dynamic>>> events;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            constraints: const BoxConstraints(maxWidth: 600),
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  floating: true,
                  backgroundColor: Get.theme.colorScheme.background,
                  centerTitle: true,
                  surfaceTintColor: Get.theme.colorScheme.background,
                  title: Text(Strs.workingPlanForYouStr.tr),
                ),
              ],
              body: Column(
                children: [
                  PlanEventContent(events: events),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlanEventContent extends StatelessWidget {
  const PlanEventContent({
    Key? key,
    required this.events,
  }) : super(key: key);

  final List<MapEntry<DateTime, List<dynamic>>> events;

  @override
  Widget build(BuildContext context) {
    var children = _getChildren(events);
    return Expanded(
      child: AnimationLimiter(
        key: UniqueKey(),
        child: ListView.builder(
          itemCount: events.length == 3 ? 6 : 8,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                verticalOffset: 50,
                child: FadeInAnimation(
                  child: children[index],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Container _getTitleContent(DateTime date) {
    var currentDate = Jalali.fromDateTime(date);
    var nowTime = DateTime.now();
    bool isToday = date.year == nowTime.year &&
        date.month == nowTime.month &&
        date.day == nowTime.day;
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

  List<Widget> _getChildren(List<MapEntry<DateTime, List<dynamic>>> userPlans) {
    var children = <Widget>[];
    children.add(_getTitleContent(userPlans.first.key));
    for (var userPlan in userPlans[0].value) {
      var plan = userPlan as Map<String, dynamic>;
      children.add(
        PlanEventListChild(
          name: plan["name"],
          event: plan["event"],
        ),
      );
    }
    children.add(_getTitleContent(userPlans[1].key));
    for (var userPlan in userPlans[1].value) {
      var plan = userPlan as Map<String, dynamic>;
      children.add(
        PlanEventListChild(
          name: plan["name"],
          event: plan["event"],
        ),
      );
    }
    children.add(_getTitleContent(userPlans[2].key));
    for (var userPlan in userPlans[2].value) {
      var plan = userPlan as Map<String, dynamic>;
      children.add(
        PlanEventListChild(
          name: plan["name"],
          event: plan["event"],
        ),
      );
    }
    try {
      children.add(_getTitleContent(userPlans[3].key));
      for (var userPlan in userPlans[3].value) {
        var plan = userPlan as Map<String, dynamic>;
        children.add(
          PlanEventListChild(
            name: plan["name"],
            event: plan["event"],
          ),
        );
      }
      // ignore: empty_catches
    } catch (e) {}
    return children;
  }
}

class PlanEventListChild extends StatelessWidget {
  const PlanEventListChild({
    Key? key,
    required this.name,
    required this.event,
  }) : super(key: key);

  final String name;
  final String event;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              event,
              style: Get.theme.textTheme.bodyText1,
            ),
          ),
        ],
      ),
    );
  }
}
