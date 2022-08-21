import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../lang/strs.dart';
import '../loading_widget/loading_widget.dart';

typedef Builder = Widget Function(BuildContext context, Object? data);

class CustomFutureBuilder extends StatelessWidget {
  const CustomFutureBuilder({
    Key? key,
    this.future,
    this.isFutureReturnData = true,
    required this.builder,
  }) : super(key: key);

  final Future<Object?>? future;
  final bool isFutureReturnData;
  final Builder builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          try {
            if (snapshot.hasError && isFutureReturnData && !snapshot.hasData) {
              throw Exception();
            }
            return builder(context, snapshot.data);
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
