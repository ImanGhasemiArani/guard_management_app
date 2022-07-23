import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../lang/strs.dart';

late final TextEditingController _usernameController = TextEditingController();
late final TextEditingController _passwordController = TextEditingController();
RxString _errorMessage = "".obs;

class ScreenLogIn extends StatelessWidget {
  const ScreenLogIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      //   resizeToAvoidBottomInset: false,
      backgroundColor: Get.theme.colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
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
                    child: _getUsernameTextField(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: _getPasswordTextField(),
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
      ),
    );
  }

  Widget _getPasswordTextField() {
    RxBool isVisiblePassword = true.obs;
    return Obx(
      () => TextField(
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
            borderSide: BorderSide(color: Get.theme.colorScheme.onBackground),
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
      ),
    );
  }

  Widget _getUsernameTextField() {
    return TextField(
      controller: _usernameController,
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
          onPressed: _onSupportButtonPressed,
          child: Text(
            Strs.supportStr.tr,
            style:
                TextStyle(fontFamily: Get.theme.textTheme.button!.fontFamily),
          ),
        ),
        Tooltip(
            message: Strs.forgotPasswordDescriptionStr.tr,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(Strs.forgotPasswordStr.tr),
                Icon(
                  CupertinoIcons.info,
                  color: Get.theme.colorScheme.onBackground,
                ),
              ],
            )),
      ],
    );
  }

  void _onSupportButtonPressed() {}

  void _onLoginPressed() {
    final phone = _usernameController.text;
    final password = _passwordController.text;
    if (RegExp(r"^[0]{0,1}9[0-9]{9}$").hasMatch(phone)) {
      if (password.isNotEmpty) {
        _errorMessage.value = "";
        _usernameController.dispose();
        _passwordController.dispose();
      } else {
        _errorMessage.value = Strs.passwordIsEmptyStr.tr;
      }
    } else {
      _errorMessage.value = Strs.phoneNumberIsInvalidStr.tr;
    }
  }

  Widget _getErrorMessageBox() {
    return Obx(
      () => Visibility(
        visible: _errorMessage.value.isNotEmpty,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            _errorMessage.value,
            style: const TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      ),
    );
  }
}
