import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../lang/strs.dart';
import '../../services/server_service.dart';
import '../../utils/show_toast.dart';
import '../screen_log_in.dart';

// ignore: must_be_immutable
class ScreenAccount extends HookWidget {
  ScreenAccount({Key? key}) : super(key: key);

  late TextEditingController _passwordController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  Widget build(BuildContext context) {
    _passwordController = useTextEditingController();
    _emailController = useTextEditingController();
    _phoneController = useTextEditingController();
    var high = MediaQuery.of(context).size.height / 3;
    return FutureBuilder(
      future: ServerService.updateCurrentUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null ||
              !snapshot.hasData ||
              !(snapshot.data as MapEntry).key) {
            return Center(
              child: Text(
                Strs.failedToLoadErrorStr.tr,
                style: Get.theme.textTheme.subtitle2,
              ),
            );
          } else {
            try {
              return Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 25),
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
                                  const NameContent(),
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
                                PhoneContent(phoneController: _phoneController),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Divider(thickness: 2),
                                ),
                                EmailContent(emailController: _emailController),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Divider(thickness: 2),
                                ),
                                PasswordContent(
                                    passwordController: _passwordController),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } catch (e) {
              return Center(
                child: Text(
                  Strs.failedToLoadErrorStr.tr,
                  style: Get.theme.textTheme.subtitle2,
                ),
              );
            }
          }
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
    try {
      ServerService.logoutUser().then((value) => Get.off(ScreenLogin()));
    } catch (e) {
      showSnackbar("$e".replaceAll("Exception:", ""));
    }
  }
}

class NameContent extends StatelessWidget {
  const NameContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        direction: Axis.vertical,
        children: [
          Text(
            ServerService.currentUser.name!,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "${ServerService.currentUser.userType} - ${ServerService.currentUser.post}",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class PasswordContent extends StatelessWidget {
  const PasswordContent({
    Key? key,
    required this.passwordController,
  }) : super(key: key);

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
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
              final RxBool isVisiblePassword = true.obs;
              return Obx(
                () => TextField(
                  controller: passwordController,
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
                      enableFeedback: false,
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

  void _onEditPasswordSaveButtonPressed() {
    FocusManager.instance.primaryFocus!.unfocus();
    final password = passwordController.text;
    if (password.isEmpty) {
      return;
    }
    try {
      ServerService.currentUser.updatePassword(password);
    } catch (e) {
      showSnackbar("$e".replaceAll("Exception:", ""));
    }
  }
}

class EmailContent extends StatelessWidget {
  const EmailContent({
    Key? key,
    required this.emailController,
  }) : super(key: key);

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    final RxBool isEditable = false.obs;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: Obx(
                () => TextField(
                  controller: emailController..text = ServerService.currentUser.email ?? "",
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
            ),
            IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 10),
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

  void _onEditEmailSaveButtonPressed() {
    FocusManager.instance.primaryFocus!.unfocus();
    final email = emailController.text;
    try {
      ServerService.currentUser.updateEmail(email);
    } catch (e) {
      showSnackbar("$e".replaceAll("Exception:", ""));
    }
  }
}

class PhoneContent extends StatelessWidget {
  const PhoneContent({
    Key? key,
    required this.phoneController,
  }) : super(key: key);

  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    final RxBool isEditable = false.obs;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: Obx(
                () => TextField(
                  controller: phoneController..text = ServerService.currentUser.phone ?? "",
                  readOnly: !isEditable.value,
                  decoration: InputDecoration(
                    labelText: Strs.phoneNumberStr.tr,
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
                  keyboardType: TextInputType.phone,
                ),
              ),
            ),
            IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
          () => Visibility(
            visible: isEditable.value,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoButton(
                onPressed: () {
                  _onEditPhoneSaveButtonPressed();
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

  void _onEditPhoneSaveButtonPressed() {
    FocusManager.instance.primaryFocus!.unfocus();
    final phone = phoneController.text;
    try {
      ServerService.currentUser.updatePhone(phone);
    } catch (e) {
      showSnackbar("$e".replaceAll("Exception:", ""));
    }
  }
}
