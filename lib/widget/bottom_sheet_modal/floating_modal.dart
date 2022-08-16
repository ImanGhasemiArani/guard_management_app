import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FloatingModal extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const FloatingModal({Key? key, required this.child, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Material(
          color: Colors.transparent,
          clipBehavior: Clip.none,
          borderRadius: BorderRadius.circular(20),
          child: child,
        ),
      ),
    );
  }
}

Future<T> showFloatingModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
}) async {
  final result = await showCustomModalBottomSheet(
      enableDrag: false,
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      builder: builder,
      containerWidget: (_, animation, child) => Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            child: FloatingModal(
              child: child,
            ),
          ),
      expand: false);

  return result;
}
