import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

import '../../lang/strs.dart';
import '../../services/server_service.dart';
import '../../utils/data_utils.dart';
import '../../widget/loading_widget/loading_widget.dart';
import '../../widget/staggered_animations/flutter_staggered_animations.dart';

typedef OnUserPicked = void Function(MapEntry<String, String> user);

// ignore: must_be_immutable
class UserPicker extends HookWidget {
  UserPicker({
    Key? key,
    this.onUserPicked,
  }) : super(key: key);

  late ScrollController _scrollController;
  final OnUserPicked? onUserPicked;

  @override
  Widget build(BuildContext context) {
    _scrollController = useScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Strs.selectSupplierStr.tr,
          style: Get.theme.textTheme.bodyLarge,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ScaffoldBody(
        scrollController: _scrollController,
        onUserPicked: onUserPicked,
      ),
    );
  }
}

class ScaffoldBody extends StatelessWidget {
  const ScaffoldBody({
    Key? key,
    required this.scrollController,
    this.onUserPicked,
  }) : super(key: key);

  final ScrollController scrollController;
  final OnUserPicked? onUserPicked;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ServerService.getUserMapUsernameToName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          try {
            if (!snapshot.hasData || snapshot.data == null) throw Exception();
            var usersMap = DataUtils.filterCurrentUserFromUsersMap(
                snapshot.data as Map<String, String>);
            return SafeArea(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: ShiftsListView(
                    users: usersMap,
                    onUserPicked: onUserPicked,
                  ),
                ),
              ),
            );
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

class ShiftsListView extends StatelessWidget {
  const ShiftsListView({
    Key? key,
    required this.users,
    this.onUserPicked,
  }) : super(key: key);

  final Map<String, String> users;
  final OnUserPicked? onUserPicked;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      key: UniqueKey(),
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 50,
              child: FadeInAnimation(
                child: ShiftsListTile(
                  user: users.entries.elementAt(index),
                  onUserPicked: onUserPicked,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ShiftsListTile extends StatelessWidget {
  const ShiftsListTile({
    Key? key,
    required this.user,
    this.onUserPicked,
  }) : super(key: key);

  final MapEntry<String, String> user;
  final OnUserPicked? onUserPicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CupertinoButton(
            onPressed: () {
              onUserPicked?.call(user);
            },
            padding: EdgeInsets.zero,
            child: Text(Strs.selectStr.tr,
                style: Get.theme.textTheme.subtitle2!.copyWith(
                  color: Get.theme.colorScheme.primary,
                )),
          ),
          Text(
            user.value,
            style: Get.theme.textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}
