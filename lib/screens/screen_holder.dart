import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

abstract class ScreenHolder extends HookWidget {
  const ScreenHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context);
}
