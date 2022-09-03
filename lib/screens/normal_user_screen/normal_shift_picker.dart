import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../lang/strs.dart';
import '../../model/user.dart';
import '../../utils/data_utils.dart';
import '../../widget/calendar/shamsi_table_calendar.dart';
import '../../widget/future_builder/custom_future_builder.dart';
import '../../widget/staggered_animations/flutter_staggered_animations.dart';
import '../../widget/tile/shift_list_tile.dart';

Rx<DateTime> currentSelectedDate =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).obs;

class ShiftPicker extends StatelessWidget {
  const ShiftPicker({
    Key? key,
    this.onShiftPicked,
    this.future,
    this.isShowAppBar = true,
    this.isShowMarkCalendar = true,
    this.isShowExchangeableBanner = true,
    this.isFilterCurrentUser = true,
  }) : super(key: key);

  final OnShiftPicked? onShiftPicked;
  final Future<Object?>? future;
  final bool isShowAppBar;
  final bool isShowMarkCalendar;
  final bool isShowExchangeableBanner;
  final bool isFilterCurrentUser;

  @override
  Widget build(BuildContext context) {
    currentSelectedDate.value =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return Scaffold(
      appBar: isShowAppBar ? _buildAppBar() : null,
      body: BodyWidget(
        onShiftPicked: onShiftPicked,
        future: future,
        isShowMarkCalendar: isShowMarkCalendar,
        isShowExchangeableBanner: isShowExchangeableBanner,
        isFilterCurrentUser: isFilterCurrentUser,
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        title: Text(
          Strs.selectShiftStr.tr,
          style: Get.theme.textTheme.bodyLarge,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      );
}

// ignore: must_be_immutable
class BodyWidget extends HookWidget {
  BodyWidget({
    Key? key,
    this.onShiftPicked,
    this.future,
    this.isShowMarkCalendar = true,
    this.isShowExchangeableBanner = true,
    this.isFilterCurrentUser = true,
  }) : super(key: key);

  late ScrollController _scrollController;
  final OnShiftPicked? onShiftPicked;
  final Future<Object?>? future;
  final bool isShowMarkCalendar;
  final bool isShowExchangeableBanner;
  final bool isFilterCurrentUser;

  @override
  Widget build(BuildContext context) {
    _scrollController = useScrollController();
    return ClipRect(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: CustomFutureBuilder(
          future: future,
          builder: (context, data) {
            Map<DateTime, List> events;
            try {
              events =
                  DataUtils.convertPlanToEvents([data as Map<String, dynamic>]);
            } catch (e) {
              events = DataUtils.convertPlanToEvents(
                  data as List<Map<String, dynamic>>);
            }
            //   RxInt segmentController = 0.obs;
            return CustomScrollView(
              controller: _scrollController,
              clipBehavior: Clip.none,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate(
                  AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 500),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      horizontalOffset: 50,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      CalendarContent(
                        events: isFilterCurrentUser
                            ? DataUtils.filterCurrentUserFromEventsMap(events)
                            : events,
                        scrollController: _scrollController,
                        isShowMarkCalendar: isShowMarkCalendar,
                      ),
                      // Padding(
                      //   padding:
                      //       const EdgeInsets.only(top: 20, right: 20, left: 20),
                      //   child: Obx(
                      //     () => CustomSlidingSegmentedControl<int>(
                      //       initialValue: segmentController.value,
                      //       children: {
                      //         1: Text(
                      //           Strs.eventDayContentTitleStr.tr,
                      //           style: Get.theme.textTheme.subtitle2,
                      //         ),
                      //         0: Text(
                      //           Strs.workingPlanTitleStr.tr,
                      //           style: Get.theme.textTheme.subtitle2,
                      //         ),
                      //       },
                      //       onValueChanged: (index) {
                      //         _scrollController.jumpTo(0);
                      //         segmentController.value = index;
                      //       },
                      //       decoration: BoxDecoration(
                      //         color: CupertinoColors.lightBackgroundGray,
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //       thumbDecoration: BoxDecoration(
                      //         color: Colors.white,
                      //         borderRadius: BorderRadius.circular(8),
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: Colors.black.withOpacity(.3),
                      //             blurRadius: 4.0,
                      //             spreadRadius: 1.0,
                      //             offset: const Offset(0.0, 2.0),
                      //           ),
                      //         ],
                      //       ),
                      //       isStretch: true,
                      //       height: 35,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                )),
                Obx(
                  () {
                    var eventShifts = events[currentSelectedDate.value] ?? [];
                    return ShiftListView(
                      shifts: eventShifts,
                      onShiftPicked: onShiftPicked,
                      isShowExchangeableBanner: isShowExchangeableBanner,
                      isFilterCurrentUser: isFilterCurrentUser,
                    );
                  },
                ),
                //   Obx(
                //     () {
                //       var eventShifts = events[currentSelectedDate.value] ?? [];
                //       return segmentController.value == 0
                //           ? ShiftListView(
                //               shifts: eventShifts,
                //               onShiftPicked: onShiftPicked,
                //             )
                //           : const DayEventListView();
                //     },
                //   ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ShiftListView extends StatelessWidget {
  const ShiftListView({
    Key? key,
    required this.shifts,
    this.onShiftPicked,
    this.isShowExchangeableBanner = true,
    this.isFilterCurrentUser = true,
  }) : super(key: key);

  final List<dynamic> shifts;
  final OnShiftPicked? onShiftPicked;
  final bool isShowExchangeableBanner;
  final bool isFilterCurrentUser;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      key: UniqueKey(),
      delegate: SliverChildListDelegate(
        addAutomaticKeepAlives: true,
        AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 500),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 50,
            child: FadeInAnimation(
              child: widget,
            ),
          ),
          children: List.generate(
            shifts.length + 1,
            (index) {
              if (index == 0) {
                return _getFirstContent();
              }
              return ShiftListTile(
                shift: shifts[index - 1],
                onShiftPicked: onShiftPicked,
                isShowExchangeableBanner: isShowExchangeableBanner,
                isFilterCurrentUser: isFilterCurrentUser,
              );
            },
          ),
        ),
      ),
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
      alignment: Alignment.centerRight,
      child: Text(
        "${Strs.workingPlanStr.tr}$title",
        style: TextStyle(
          fontFamily: Get.theme.textTheme.subtitle1?.fontFamily,
          fontStyle: Get.theme.textTheme.subtitle1?.fontStyle,
          fontSize: Get.theme.textTheme.subtitle1?.fontSize,
          fontWeight: Get.theme.textTheme.subtitle1?.fontWeight,
          letterSpacing: Get.theme.textTheme.subtitle1?.letterSpacing,
        ),
      ),
    );
  }
}

// class DayEventListView extends StatelessWidget {
//   const DayEventListView({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: ServerService.getDayEvents(currentSelectedDate.value),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           if (snapshot.data == null || !snapshot.hasData) {
//             return Center(
//               child: Text(
//                 Strs.failedToLoadErrorStr.tr,
//                 style: Get.theme.textTheme.subtitle2,
//               ),
//             );
//           } else {
//             try {
//               var dayMap = snapshot.data as Map<String, dynamic>;
//               var events = dayMap['events'] as List<dynamic>;
//               return SliverList(
//                 delegate: SliverChildListDelegate(
//                   AnimationConfiguration.toStaggeredList(
//                     duration: const Duration(milliseconds: 500),
//                     childAnimationBuilder: (widget) => SlideAnimation(
//                       verticalOffset: 50,
//                       child: FadeInAnimation(
//                         child: widget,
//                       ),
//                     ),
//                     children: List.generate(
//                       events.length + 1,
//                       (index) {
//                         if (index == 0) {
//                           return _getFirstContent(
//                               dayMap['is_holiday'] ?? false);
//                         }
//                         return _getEventChild(events, index - 1);
//                       },
//                     ),
//                   ),
//                 ),
//               );
//             } catch (e) {
//               return Center(
//                 child: Text(
//                   Strs.failedToLoadErrorStr.tr,
//                   style: Get.theme.textTheme.subtitle2,
//                 ),
//               );
//             }
//           }
//         } else {
//           return const Expanded(child: LoadingWidget());
//         }
//       },
//     );
//   }

//   Container _getFirstContent(bool isHoliday) {
//     var currentDate = Jalali.fromDateTime(currentSelectedDate.value);
//     var nowTime = DateTime.now();
//     bool isToday = currentSelectedDate.value.year == nowTime.year &&
//         currentSelectedDate.value.month == nowTime.month &&
//         currentSelectedDate.value.day == nowTime.day;
//     String title =
//         "${isToday ? ' ${Strs.todayStr.tr}' : ''} ${dayFull[currentDate.weekDay - 1]}  ${currentDate.day}  ${monthFull[currentDate.month - 1]}  ${currentDate.year} ${isHoliday ? '- ${Strs.holidayStr.tr}' : ''}";
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       height: 50,
//       color: Get.theme.colorScheme.background,
//       alignment: Alignment.centerRight,
//       child: Text(
//         "${Strs.eventsDayStr.tr}$title",
//         style: Get.theme.textTheme.subtitle1,
//       ),
//     );
//   }

//   Container _getEventChild(List<dynamic> events, int index) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       alignment: Alignment.centerRight,
//       child: Text(
//         events[index]['description'],
//         style: Get.theme.textTheme.subtitle1,
//         textDirection: TextDirection.rtl,
//       ),
//     );
//   }
// }

class CalendarContent extends StatelessWidget {
  const CalendarContent({
    Key? key,
    required this.events,
    this.scrollController,
    this.segmentController,
    this.isShowMarkCalendar = true,
  }) : super(key: key);

  final Map<DateTime, List<dynamic>>? events;
  final ScrollController? scrollController;
  final RxInt? segmentController;
  final bool isShowMarkCalendar;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ShamsiTableCalendar(
        events: events,
        onDaySelected: (day) {
          scrollController?.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
          segmentController?.value = 0;
          currentSelectedDate.value = day.toDateTime();
        },
        eventMarkerBuilder: (date, event) {
          return isShowMarkCalendar
              ? Container(
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      min(event.length, 4),
                      (index) {
                        final Color? color;
                        if ((event[index])['shift']['des'] ==
                            ShiftType.D.name) {
                          color = Colors.amber;
                        } else if ((event[index])['shift']['des'] ==
                            ShiftType.N.name) {
                          color = Colors.indigoAccent;
                        } else {
                          color = Colors.tealAccent;
                        }
                        return Container(
                          height: 5,
                          width: 5,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    ),
                  ),
                )
              : const SizedBox();
        },
      ),
    );
  }
}
