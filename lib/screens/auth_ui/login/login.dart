// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickcart/constants/constants.dart';
import 'package:quickcart/constants/routes.dart';
import 'package:quickcart/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:quickcart/screens/auth_ui/sign_up/sign_up.dart';
import 'package:quickcart/widgets/primary_button/primary_button.dart';
import 'package:quickcart/widgets/top_titles/top_titles.dart';

import '../../custom_bottom_bar/custom_bottom_bar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isShowPassword = true;
  int loginAttempts = 0;
  bool isWaiting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopTitles(subtitle: "Welcome Back To $appName", title: "Login"),
              const SizedBox(
                height: 36.0,
              ),
              TextFormField(
                controller: email,
                decoration: const InputDecoration(
                  hintText: "E-mail",
                  prefixIcon: Icon(
                    Icons.email_outlined,
                  ),
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              TextFormField(
                controller: password,
                obscureText: isShowPassword,
                decoration: InputDecoration(
                  hintText: "Password",
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
                      child: Icon(
                        isShowPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      )),
                ),
              ),
              const SizedBox(
                height: 36.0,
              ),
              PrimaryButton(
                title: "Login",
                onPressed: () async {
                  if (isWaiting) {
                    removeToastQueues();
                    showMessage("Please wait for 30 seconds");
                    return;
                  }

                  if (loginAttempts >= 3) {
                    setState(() {
                      isWaiting = true;
                    });
                    await Future.delayed(const Duration(seconds: 30));
                    setState(() {
                      loginAttempts = 0;
                      isWaiting = false;
                    });
                    return;
                  }

                  bool isVaildated = loginVaildation(email.text, password.text);
                  if (!isVaildated) return;

                  bool isLogined = await FirebaseAuthHelper.instance
                      .login(email.text, password.text, context);

                  if (isLogined) {
                    Routes.instance.pushAndRemoveUntil(
                        widget: const CustomBottomBar(), context: context);
                    return;
                  }

                  setState(() {
                    loginAttempts += 1;
                  });

                  if (loginAttempts >= 3) {
                    setState(() {
                      isWaiting = true;
                    });
                    await Future.delayed(const Duration(seconds: 30));
                    setState(() {
                      loginAttempts = 0;
                      isWaiting = false;
                    });
                  }
                },
              ),
              const SizedBox(
                height: 24.0,
              ),
              const Center(child: Text("Don't have an account?")),
              const SizedBox(
                height: 12.0,
              ),
              Center(
                child: CupertinoButton(
                  onPressed: () {
                    Routes.instance
                        .push(widget: const SignUp(), context: context);
                  },
                  child: Text(
                    "Create an account",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CupertinoButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          padding: EdgeInsets.zero,
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
