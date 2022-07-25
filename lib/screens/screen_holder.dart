import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/btn_nav_bar/button_navigation_bar.dart';

final PageController _controller = PageController(initialPage: 1);

class ScreenHolder extends StatefulWidget {
  const ScreenHolder({Key? key}) : super(key: key);

  @override
  State<ScreenHolder> createState() => _ScreenHolderState();
}

class _ScreenHolderState extends State<ScreenHolder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBody: true,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        children: [
          Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: const Center(
              child: Text('تقویم'),
            ),
          ),
          Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: const Center(
              child: Text('خانه'),
            ),
          ),
          Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: const Center(
              child: Text('اکانت'),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _getBtnNavBar(),
    );
  }

  Widget _getBtnNavBar() {
    return ButtonNavigationBar(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      children: [
        ButtonNavigationItem(
          icon: const Icon(CupertinoIcons.calendar),
          color: Get.theme.colorScheme.surface,
          onPressed: () {
            _controller.animateToPage(0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
        ),
        ButtonNavigationItem(
          icon: const Icon(CupertinoIcons.home),
          color: Get.theme.colorScheme.surface,
          onPressed: () {
            _controller.animateToPage(1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
        ),
        ButtonNavigationItem(
          icon: const Icon(CupertinoIcons.person),
          color: Get.theme.colorScheme.surface,
          onPressed: () {
            _controller.animateToPage(2,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
        ),
      ],
    );
  }
}
