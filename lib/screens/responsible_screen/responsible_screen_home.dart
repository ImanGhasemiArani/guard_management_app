import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../lang/strs.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          enableFeedback: false,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {},
          icon: const Icon(CupertinoIcons.mail),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  height: Get.size.width * 0.3,
                  width: Get.size.width * 0.3,
                  margin: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: Text(Strs.addUserStr.tr),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  height: Get.size.width * 0.3,
                  width: Get.size.width * 0.3,
                  margin: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: Text(Strs.addUserStr.tr),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
