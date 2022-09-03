import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:shamsi_date/shamsi_date.dart';

const monthFull = [
  'فروردین',
  'اردیبهشت',
  'خرداد',
  'تیر',
  'مرداد',
  'شهریور',
  'مهر',
  'آبان',
  'آذر',
  'دی',
  'بهمن',
  'اسفند'
];
const dayFull = [
  'شنبه',
  'یکشنبه',
  'دوشنبه',
  'سه شنبه',
  'چهارشنبه',
  'پنج شنبه',
  'جمعه'
];
const dayExp = [
  'ش',
  'ی',
  'د',
  'س',
  'چ',
  'پ',
  'ج',
];

const baseMonthViewLength = 49;
double cellHeight = 50;
const monthHeaderHeight = 40.0;
double calendarHeight = cellHeight * 7 + monthHeaderHeight;

var _selectedDate = Jalali.now().obs;

typedef OnDateSelected = void Function(Jalali date);
typedef EventMarkerBuilder = Widget Function(double cellHeight,Jalali date, List<dynamic> event);

class ShamsiTableCalendar extends HookWidget {
  const ShamsiTableCalendar({
    super.key,
    this.onDaySelected,
    this.events,
    this.eventMarkerBuilder,
  });

  final OnDateSelected? onDaySelected;
  final Map<DateTime, List<dynamic>>? events;
  final EventMarkerBuilder? eventMarkerBuilder;

  @override
  Widget build(BuildContext context) {
    cellHeight = Get.height * 0.4 / 7;
    calendarHeight = cellHeight * 7 + monthHeaderHeight;
    final initDate = Jalali.now();
    _selectedDate = initDate.obs;
    final minDate = Jalali(1399);
    final maxDate = Jalali(1404);
    var pageController =
        usePageController(initialPage: getMonthCount(minDate, initDate));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          MonthPageView(
            onDaySelected: onDaySelected,
            pageController: pageController,
            initDate: initDate,
            minDate: minDate,
            maxDate: maxDate,
            eventMarkerBuilder: eventMarkerBuilder,
            events: events,
          ),
          MonthHeader(
            pageController: pageController,
            minDate: minDate,
            maxDate: maxDate,
            initDate: initDate,
          ),
        ],
      ),
    );
  }
}

class MonthPageView extends StatelessWidget {
  const MonthPageView({
    super.key,
    required this.initDate,
    required this.minDate,
    required this.maxDate,
    required this.pageController,
    required this.onDaySelected,
    this.eventMarkerBuilder,
    this.events,
  });

  final OnDateSelected? onDaySelected;
  final PageController pageController;
  final Jalali initDate;
  final Jalali minDate;
  final Jalali maxDate;
  final EventMarkerBuilder? eventMarkerBuilder;
  final Map<DateTime, List<dynamic>>? events;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: calendarHeight),
        child: PageView.builder(
          controller: pageController,
          physics: const BouncingScrollPhysics(),
          itemCount: getMonthCount(minDate, maxDate) + 1,
          itemBuilder: (context, index) {
            return MonthView(
              startDate: minDate.addMonths(index),
              endDate: minDate.addMonths(index + 1),
              today: initDate,
              onDaySelected: onDaySelected,
              eventMarkerBuilder: eventMarkerBuilder,
              events: events,
            );
          },
        ),
      ),
    );
  }
}

class MonthView extends StatelessWidget {
  const MonthView({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.today,
    required this.onDaySelected,
    this.eventMarkerBuilder,
    this.events,
  });

  final Jalali startDate;
  final Jalali endDate;
  final Jalali today;
  final OnDateSelected? onDaySelected;
  final EventMarkerBuilder? eventMarkerBuilder;
  final Map<DateTime, List<dynamic>>? events;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: monthHeaderHeight,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "${monthFull[startDate.month - 1]} ${startDate.year}",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ),
        ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: calendarHeight - monthHeaderHeight),
          child: GridView.builder(
            addAutomaticKeepAlives: true,
            addRepaintBoundaries: false,
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: cellHeight,
              crossAxisCount: 7,
            ),
            itemCount: baseMonthViewLength,
            itemBuilder: ((context, index) {
              if (index < 7) {
                return FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SizedBox(
                    height: cellHeight,
                    child: Center(
                      child: Text(dayExp[index]),
                    ),
                  ),
                );
              }
              final date = startDate.addDays(index - 7 - startDate.weekDay + 1);
              if (index - 7 < startDate.weekDay - 1 ||
                  date.toDateTime().isAfter((endDate - 1).toDateTime())) {
                return const SizedBox();
              }
              return FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  height: cellHeight,
                  child: GestureDetector(
                    onTap: () {
                      _selectedDate.value = date;
                      onDaySelected?.call(date);
                    },
                    child: Obx(
                      () => DayWidget(
                        date: date,
                        today: today,
                        selectedDate: _selectedDate.value,
                        eventMarkerBuilder: eventMarkerBuilder,
                        event: events?[date.toDateTime()],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class DayWidget extends StatelessWidget {
  const DayWidget({
    Key? key,
    required this.date,
    required this.today,
    required this.selectedDate,
    EventMarkerBuilder? eventMarkerBuilder,
    this.event,
  })  : markerBuilder = eventMarkerBuilder ?? defaultEventMarkerBuilder,
        super(key: key);

  final Jalali date;
  final Jalali today;
  final Jalali selectedDate;
  final EventMarkerBuilder markerBuilder;
  final List<dynamic>? event;

  @override
  Widget build(BuildContext context) {
    final todayDateTime =
        Jalali(today.year, today.month, today.day).toDateTime();
    final selectedDateTime =
        Jalali(selectedDate.year, selectedDate.month, selectedDate.day)
            .toDateTime();
    Color? decorationColor;
    Color? color;
    BoxBorder? border;
    if (date.weekDay == 7) {
      color = Colors.red;
    }
    if (date.toDateTime().isAtSameMomentAs(todayDateTime)) {
      decorationColor = Theme.of(context).colorScheme.tertiary.withOpacity(0.5);
    }
    if (date.toDateTime().isAtSameMomentAs(selectedDateTime)) {
      color = null;
      border = Border.all(
        color: Theme.of(context).colorScheme.tertiary,
        width: 2,
      );
    }

    final dayWidget = Container(
      height: cellHeight,
      width: cellHeight,
      decoration: BoxDecoration(
        color: decorationColor,
        shape: BoxShape.circle,
        border: border,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          "${date.day}",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
          ),
        ),
      ),
    );

    if (event == null || event!.isEmpty) {
      return dayWidget;
    }

    final marker = markerBuilder.call(cellHeight,date, event!);
    return Stack(
      children: [
        dayWidget,
        Positioned(
          bottom: 0,
          right: 0,
          child: SizedBox(
            height: cellHeight,
            width: cellHeight,
            child: marker,
          ),
        ),
      ],
    );
  }
}

class MonthHeader extends StatelessWidget {
  const MonthHeader({
    super.key,
    required this.pageController,
    required this.initDate,
    required this.maxDate,
    required this.minDate,
  });

  final PageController pageController;
  final Jalali initDate;
  final Jalali minDate;
  final Jalali maxDate;

  @override
  Widget build(BuildContext context) {
    final opacity = 1.0.obs;
    pageController.addListener(
      () {
        final page = pageController.page;
        if (page == page!.round()) {
          opacity.value = 1;
        } else {
          opacity.value = 0;
        }
      },
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => AnimatedOpacity(
            duration: const Duration(milliseconds: 100),
            opacity: opacity.value,
            child: SizedBox(
              height: monthHeaderHeight,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(
                  CupertinoIcons.chevron_back,
                  size: 18,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: () {
                  pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
              ),
            ),
          ),
        ),
        Obx(
          () => AnimatedOpacity(
            duration: const Duration(milliseconds: 100),
            opacity: opacity.value,
            child: SizedBox(
              height: monthHeaderHeight,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(
                  CupertinoIcons.chevron_forward,
                  size: 18,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: () {
                  pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

int getMonthCount(Jalali startDate, Jalali endDate) {
  return (endDate.year - startDate.year) * 12 +
      (endDate.month - startDate.month);
}

Widget defaultEventMarkerBuilder(double cellHeight, Jalali date, List<dynamic> event) {
  return Container(
    height: double.infinity,
    width: double.infinity,
    alignment: Alignment.bottomCenter,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        min(event.length, 4),
        (index) => Container(
          height: 5,
          width: 5,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ),
      ),
    ),
  );
}
