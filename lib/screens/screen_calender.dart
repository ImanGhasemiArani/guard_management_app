import 'package:flutter/material.dart';

class ScreenCalender extends StatelessWidget {
  const ScreenCalender({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: const Center(
        child: Text('تقویم'),
      ),
    );
  }
}