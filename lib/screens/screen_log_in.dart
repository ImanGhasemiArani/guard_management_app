import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

import '../lang/strs.dart';
import '../services/server_service.dart';
import '../utils/show_toast.dart';
import 'screen_holder.dart';

// ignore: must_be_immutable
class ScreenLogin extends HookWidget {
  ScreenLogin({Key? key}) : super(key: key);

  final RxString _loginErrorMessage = "".obs;

  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    _usernameController = useTextEditingController();
    _passwordController = useTextEditingController();
    _emailController = useTextEditingController();
    return Scaffold(
      extendBody: true,
      backgroundColor: Get.theme.colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    Strs.loginStr.tr,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: UsernameField(usernameController: _usernameController),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: PasswordField(passwordController: _passwordController),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: EmailField(emailController: _emailController),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: _getLoginButton(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: _getSupportButton(),
                ),
                // create error massage box
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: _getErrorMessageBox(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton.filled(
        borderRadius: BorderRadius.circular(10),
        onPressed: _onLoginPressed,
        child: Text(
          Strs.loginStr.tr,
          style: TextStyle(fontFamily: Get.theme.textTheme.button!.fontFamily),
        ),
      ),
    );
  }

  Widget _getSupportButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CupertinoButton(
          onPressed: _onRestPasswordButtonPressed,
          child: Text(
            Strs.resetPasswordStr.tr,
            style:
                TextStyle(fontFamily: Get.theme.textTheme.button!.fontFamily),
          ),
        ),
        Tooltip(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            message: Strs.supportDescriptionStr.tr,
            showDuration: const Duration(seconds: 3),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(Strs.supportStr.tr),
                Icon(
                  CupertinoIcons.question_circle,
                  color: Get.theme.colorScheme.onBackground,
                ),
              ],
            )),
      ],
    );
  }

  void _onRestPasswordButtonPressed() {
    _loginErrorMessage.value = "";
    FocusManager.instance.primaryFocus!.unfocus();

    String email = _emailController.text;
    if (email.isEmpty) {
      showCupertinoDialog(
        context: Get.context!,
        builder: (BuildContext buildContext) {
          return CupertinoAlertDialog(
            title: Text(
              Strs.resetPasswordStr.tr,
              style: TextStyle(
                  fontFamily: Get.theme.textTheme.button!.fontFamily,
                  fontSize: 16),
            ),
            content: Text(
              Strs.resetPasswordDescriptionStr.tr,
              style: TextStyle(
                  fontFamily: Get.theme.textTheme.button!.fontFamily,
                  fontSize: 14),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(Strs.okStr.tr),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          );
        },
      );
    } else {
      if (!GetUtils.isEmail(email)) {
        _loginErrorMessage.value = Strs.invalidEmailErrorMessage.tr;
        return;
      }
      sendResetPasswordEmail(email);
    }
  }

  Future<void> _onLoginPressed() async {
    _loginErrorMessage.value = "";
    FocusManager.instance.primaryFocus!.unfocus();

    String phone = _usernameController.text;
    final password = _passwordController.text;
    final email = _emailController.text;
    if (phone.isEmpty || password.isEmpty) {
      _loginErrorMessage.value = Strs.emptyFieldsErrorStr.tr;
      return;
    }
    if (!RegExp(r"^[0]{0,1}9[0-9]{9}$").hasMatch(phone)) {
      _loginErrorMessage.value = Strs.invalidPhoneNumberErrorMessage.tr;
      return;
    }
    if (phone.startsWith("0")) phone = phone.substring(1);
    if (email.isNotEmpty && !GetUtils.isEmail(email)) {
      _loginErrorMessage.value = Strs.invalidEmailErrorMessage.tr;
      return;
    }

    final result =
        await loginUser(username: phone, password: password, email: email);
    if (!result.key) {
      _loginErrorMessage.value = Strs.loginFailedMessageStr.tr;
      return;
    }

    showSnackbar(Strs.loginSuccessfullyMessageStr.tr,
        duration: const Duration(seconds: 1));
    await Future.delayed(const Duration(seconds: 1));
    Get.off(ScreenHolder(), transition: Transition.cupertino);
  }

  Widget _getErrorMessageBox() {
    return Obx(
      () => Visibility(
        visible: _loginErrorMessage.value.isNotEmpty,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            _loginErrorMessage.value,
            style: const TextStyle(fontSize: 18, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class EmailField extends StatelessWidget {
  const EmailField({
    Key? key,
    required this.emailController,
  }) : super(key: key);

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: emailController,
      decoration: InputDecoration(
        labelText: Strs.emailStr.tr,
        labelStyle: const TextStyle(fontSize: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Get.theme.colorScheme.onBackground),
        ),
        suffixIcon: Tooltip(
          message: Strs.emailInputDescriptionStr.tr,
          enableFeedback: false,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          showDuration: const Duration(seconds: 3),
          child: Icon(
            CupertinoIcons.info,
            color: Get.theme.colorScheme.onBackground,
          ),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class UsernameField extends StatelessWidget {
  const UsernameField({
    Key? key,
    required this.usernameController,
  }) : super(key: key);

  final TextEditingController usernameController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: usernameController,
      decoration: InputDecoration(
        labelText: Strs.phoneNumberStr.tr,
        labelStyle: const TextStyle(fontSize: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Get.theme.colorScheme.onBackground),
        ),
        prefixText: "+98 ",
      ),
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }
}

class PasswordField extends StatelessWidget {
  const PasswordField({
    Key? key,
    required this.passwordController,
  }) : super(key: key);

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    RxBool isVisiblePassword = true.obs;
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
            borderSide: BorderSide(color: Get.theme.colorScheme.onBackground),
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
}
