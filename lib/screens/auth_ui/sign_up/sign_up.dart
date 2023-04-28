// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickcart/constants/routes.dart';
import 'package:quickcart/screens/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:quickcart/widgets/primary_button/primary_button.dart';
import 'package:quickcart/widgets/top_titles/top_titles.dart';

import '../../../constants/constants.dart';
import '../../../firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isShowPassword = true;
  TextEditingController password = TextEditingController();
  TextEditingController confirmPass = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopTitles(
                  subtitle: "Start your shopping journey with us",
                  title: "Create Account"),
              const SizedBox(
                height: 36.0,
              ),
              TextFormField(
                controller: name,
                decoration: const InputDecoration(
                  hintText: "Name",
                  prefixIcon: Icon(
                    Icons.person_outline,
                  ),
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
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
                controller: phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: "Phone",
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                  ),
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              TextFormField(
                controller: address,
                keyboardType: TextInputType.streetAddress,
                decoration: const InputDecoration(
                  hintText: "Address",
                  prefixIcon: Icon(Icons.place_outlined),
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
                      child: const Icon(
                        Icons.visibility,
                        color: Colors.grey,
                      )),
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              TextFormField(
                controller: confirmPass,
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
                      child: const Icon(
                        Icons.visibility,
                        color: Colors.grey,
                      )),
                ),
              ),
              const SizedBox(
                height: 36.0,
              ),
              PrimaryButton(
                title: "Create an account",
                onPressed: () async {
                  bool isVaildated = signUpVaildation(email.text, password.text, confirmPass.text, 
                      name.text, phone.text, address.text);
                  if (isVaildated) {
                    bool isLogined = await FirebaseAuthHelper.instance.signUp(
                        name.text,
                        email.text,
                        password.text,
                        phone.text,
                        address.text,
                        context);
                    if (isLogined) {
                      Routes.instance.pushAndRemoveUntil(
                          widget: const CustomBottomBar(), context: context);
                    }
                  }
                },
              ),
              const SizedBox(
                height: 36.0,
              ),
              const Center(child: Text("I have already an account?")),
              const SizedBox(
                height: 6.0,
              ),
              Center(
                child: CupertinoButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Login",
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
