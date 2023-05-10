import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickcart/constants/constants.dart';
import 'package:quickcart/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';

import '../../widgets/primary_button/primary_button.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  final ValueNotifier<bool> _isValid = ValueNotifier<bool>(false);
  bool isShowPassword = true;

  void validateInputs() {
    if (newPassword.text.isEmpty && confirmPassword.text.isEmpty) {
      _isValid.value = false;
    } else {
      _isValid.value = true;
    }
  }

  @override
  void initState() {
    super.initState();
    newPassword.addListener(validateInputs);
    confirmPassword.addListener(validateInputs);
  }

  @override
  void dispose() {
    newPassword.dispose();
    confirmPassword.dispose();
    _isValid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Change Password",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: newPassword,
            obscureText: isShowPassword,
            decoration: InputDecoration(
              hintText: "New Password",
              prefixIcon: const Icon(
                Icons.password_sharp,
              ),
              suffixIcon: CupertinoButton(
                  onPressed: () {
                    setState(() {
                      isShowPassword = !isShowPassword;
                    });
                  },
                  padding: EdgeInsets.zero,
                  child: isShowPassword
                      ? const Icon(
                          Icons.visibility,
                          color: Colors.grey,
                        )
                      : const Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                        )),
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          TextFormField(
            controller: confirmPassword,
            obscureText: isShowPassword,
            decoration: InputDecoration(
              hintText: "Confirm Password",
              prefixIcon: const Icon(
                Icons.password_sharp,
              ),
              suffixIcon: CupertinoButton(
                  onPressed: () {
                    setState(() {
                      isShowPassword = !isShowPassword;
                    });
                  },
                  padding: EdgeInsets.zero,
                  child: isShowPassword
                      ? const Icon(
                          Icons.visibility,
                          color: Colors.grey,
                        )
                      : const Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                        )),
            ),
          ),
          const SizedBox(
            height: 36.0,
          ),
          ValueListenableBuilder<bool>(
              valueListenable: _isValid,
              builder: (context, isValid, _) {
                return PrimaryButton(
                  title: "Update",
                  onPressed: isValid
                      ? () async {
                          if (confirmPassword.text == newPassword.text) {
                            FirebaseAuthHelper.instance
                                .changePassword(newPassword.text, context);
                          } else {
                            showMessage("Confirm Password is not match");
                          }
                        }
                      : null,
                );
              }),
        ],
      ),
    );
  }
}
