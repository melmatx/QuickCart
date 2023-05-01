import 'package:flutter/material.dart';
import 'package:quickcart/constants/asset_images.dart';
import 'package:quickcart/constants/routes.dart';
import 'package:quickcart/screens/auth_ui/login/login.dart';
import 'package:quickcart/screens/auth_ui/sign_up/sign_up.dart';
import 'package:quickcart/widgets/primary_button/primary_button.dart';
import 'package:quickcart/widgets/top_titles/top_titles.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: TopTitles(
                    subtitle: "Your One Stop Shop for All Your Needs", title: "QuickCart", isCenter: true),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Center(
                child: Image.asset(
                  AssetsImages.instance.welcomeImage,
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     CupertinoButton(
              //       onPressed: () {},
              //       padding: EdgeInsets.zero,
              //       child: const Icon(
              //         Icons.facebook,
              //         size: 35,
              //         color: Colors.blue,
              //       ),
              //     ),
              //     const SizedBox(
              //       width: 12.0,
              //     ),
              //     CupertinoButton(
              //       onPressed: () {},
              //       padding: EdgeInsets.zero,
              //       child: Image.asset(
              //         AssetsImages.instance.googleLogo,
              //         scale: 30.0,
              //       ),
              //     ),
              //   ],
              // ),
              PrimaryButton(
                title: "Login",
                onPressed: () {
                  Routes.instance.push(widget: const Login(), context: context);
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              PrimaryButton(
                title: "Sign Up",
                onPressed: () {
                  Routes.instance.push(widget: const SignUp(), context: context);
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(),
    );
  }
}
