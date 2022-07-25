import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:guard_management_app/utils/show_toast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../lang/strs.dart';
import '../services/database_service.dart';
import '../services/service_locator.dart';
import 'screen_log_in.dart';

// ignore: must_be_immutable
class ScreenAccount extends HookWidget {
  ScreenAccount({Key? key}) : super(key: key);

  late TextEditingController _passwordController;
  late TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    _passwordController = useTextEditingController();
    _emailController = useTextEditingController();
    var high = MediaQuery.of(context).size.height / 3;
    return FutureBuilder(
      future: updateCurrentUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          minHeight: high,
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Wrap(
                            direction: Axis.vertical,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              _getNameWidget(),
                              _getLogoutButton(),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          minHeight: high * 2,
                        ),
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 400),
                          padding: const EdgeInsets.symmetric(
                              vertical: 40, horizontal: 25),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(children: [
                            _getUsernameWidget(),
                            const Divider(thickness: 2),
                            _getEmailWidget(),
                            const Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Divider(thickness: 2),
                            ),
                            _getPasswordChangeWidget(),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: LoadingAnimationWidget.dotsTriangle(
              color: const Color(0xfff5d042),
              size: 40,
            ),
          );
        }
      },
    );
  }

  Widget _getEmailWidget() {
    final RxBool isEditable = false.obs;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              Strs.emailProfileStr.tr,
              style: const TextStyle(fontSize: 18),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                isEditable.value = true;
              },
              icon: const Icon(
                CupertinoIcons.pencil,
              ),
            ),
          ],
        ),
        Obx(
          () => TextField(
            controller: _emailController..text = currentUser.emailAddress ?? "",
            readOnly: !isEditable.value,
            decoration: InputDecoration(
              labelText: Strs.emailStr.tr,
              labelStyle: const TextStyle(fontSize: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: Get.theme.colorScheme.onBackground),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        Obx(
          () => Visibility(
            visible: isEditable.value,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoButton(
                onPressed: () {
                  _onEditEmailSaveButtonPressed();
                  isEditable.value = false;
                },
                child: Text(
                  Strs.saveStr.tr,
                  style: TextStyle(
                      fontFamily: Get.theme.textTheme.button!.fontFamily),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getPasswordChangeWidget() {
    final RxBool isEditPassword = false.obs;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(
          () {
            if (!isEditPassword.value) {
              return CupertinoButton(
                onPressed: () {
                  isEditPassword.value = true;
                },
                child: Text(
                  Strs.editPasswordStr.tr,
                  style: TextStyle(
                      fontFamily: Get.theme.textTheme.button!.fontFamily),
                ),
              );
            } else {
              RxBool isVisiblePassword = true.obs;
              return TextField(
                controller: _passwordController,
                obscureText: isVisiblePassword.value,
                decoration: InputDecoration(
                  labelText: Strs.passwordStr.tr,
                  labelStyle: const TextStyle(fontSize: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Get.theme.colorScheme.onBackground),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      isVisiblePassword.value = !isVisiblePassword.value;
                    },
                    borderRadius: BorderRadius.circular(100),
                    child: isVisiblePassword.value
                        ? const Icon(
                            CupertinoIcons.eye_slash,
                          )
                        : const Icon(
                            CupertinoIcons.eye,
                          ),
                  ),
                ),
              );
            }
          },
        ),
        Obx(
          () => Visibility(
            visible: isEditPassword.value,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoButton(
                onPressed: () {
                  _onEditPasswordSaveButtonPressed();
                  isEditPassword.value = false;
                },
                child: Text(
                  Strs.saveStr.tr,
                  style: TextStyle(
                      fontFamily: Get.theme.textTheme.button!.fontFamily),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _getUsernameWidget() {
    return Wrap(
      direction: Axis.vertical,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          Strs.phoneNumberProfileStr.tr,
          style: const TextStyle(fontSize: 18),
        ),
        Tooltip(
          message: "+98 ${currentUser.username!}",
          child: Text(
            "+98 ${currentUser.username!}",
            style: const TextStyle(
              fontSize: 20,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _getNameWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        direction: Axis.vertical,
        children: [
          Text(
            currentUser.get('name') as String,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "${currentUser.get('roleRank') as String} - ${currentUser.get('rank') as String}",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _getLogoutButton() {
    return CupertinoButton(
      onPressed: _onLogoutButtonPressed,
      child: Text(
        Strs.logoutStr.tr,
        style: TextStyle(
          fontFamily: Get.theme.textTheme.button!.fontFamily,
          color: Colors.red,
        ),
      ),
    );
  }

  void _onLogoutButtonPressed() {
    currentUser.logout().then((value) {
      secureStorage.deleteAll();
      Get.off(ScreenLogin());
    });
  }

  void _onEditEmailSaveButtonPressed() {
    FocusManager.instance.primaryFocus!.unfocus();
    final email = _emailController.text;
    if (email.isNotEmpty && !GetUtils.isEmail(email)) {
      _emailController.text = currentUser.emailAddress ?? "";
      return;
    }
    updateEmail(email).then(
      (value) {
        showSnackbar(Strs.successfullyWorkStr.tr);
      },
    );
  }

  void _onEditPasswordSaveButtonPressed() {
    FocusManager.instance.primaryFocus!.unfocus();
    final password = _passwordController.text;
    if (password.isEmpty) {
      return;
    }
    updatePassword(password).then(
      (value) {
        showSnackbar(Strs.successfullyWorkStr.tr);
        Get.off(ScreenLogin());
      },
    );
  }
}
