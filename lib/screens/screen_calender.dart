import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/calendar/calendar.dart';


class ScreenCalender extends StatelessWidget {
  const ScreenCalender({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: const SafeArea(
        child: CalendarContent(),
      ),
    );
  }
}

class CalendarContent extends StatelessWidget {
  const CalendarContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return JalaliTableCalendar(
      context: context,
      marker: (date, events) {
        return Positioned(
          top: -4,
          left: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(6.0),
            child: Text(
              events!.length.toString(),
              style: TextStyle(
                color: Get.theme.colorScheme.onPrimary,
              ),
            ),
          ),
        );
      },
    );
  }
}
