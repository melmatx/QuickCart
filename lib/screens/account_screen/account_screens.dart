import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickcart/constants/routes.dart';
import 'package:quickcart/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:quickcart/screens/about_us/about_us.dart';
import 'package:quickcart/screens/change_password/change_password.dart';
import 'package:quickcart/screens/chat_screen/chat_screen.dart';
import 'package:quickcart/screens/edit_profile/edit_profile.dart';
import 'package:quickcart/screens/favourite_screen/favourite_screen.dart';
import 'package:quickcart/screens/onboarding/onboarding.dart';
import 'package:quickcart/screens/order_screen/order_screen.dart';
import 'package:quickcart/widgets/primary_button/primary_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';
import '../../provider/app_provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  _storeOnboardInfo() async {
    int isNotViewed = 1;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isNotViewed);
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          "My Account",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 65.0),
        child: FloatingActionButton(
            child: const Icon(Icons.chat),
            onPressed: () {
              Routes.instance
                  .push(widget: const ChatScreen(), context: context);
            }),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 260,
              child: Column(
                children: [
                  const SizedBox(
                    height: 12.0,
                  ),
                  appProvider.getUserInformation.image == null ||
                          appProvider.getUserInformation.image!.isEmpty
                      ? const Icon(
                          Icons.person_outline,
                          size: 120,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(
                              appProvider.getUserInformation.image!),
                          radius: 60,
                        ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    appProvider.getUserInformation.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 3.0,
                  ),
                  Text(
                    appProvider.getUserInformation.email,
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  SizedBox(
                    width: 135,
                    child: PrimaryButton(
                      title: "Edit Profile",
                      onPressed: () {
                        Routes.instance.push(
                            widget: const EditProfile(), context: context);
                      },
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 6.0,
            ),
            SizedBox(
              height: 350,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Routes.instance
                          .push(widget: const OrderScreen(), context: context);
                    },
                    leading: const Icon(Icons.shopping_bag_outlined),
                    title: const Text("Your Orders"),
                  ),
                  ListTile(
                    onTap: () {
                      Routes.instance.push(
                          widget: const FavouriteScreen(), context: context);
                    },
                    leading: const Icon(Icons.favorite_outline),
                    title: const Text("Wishlist"),
                  ),
                  ListTile(
                    onTap: () {
                      Routes.instance
                          .push(widget: const AboutUs(), context: context);
                    },
                    leading: const Icon(Icons.info_outline),
                    title: const Text("About us"),
                  ),
                  ListTile(
                    onTap: () {
                      Routes.instance.push(
                          widget: const ChangePassword(), context: context);
                    },
                    leading: const Icon(Icons.change_circle_outlined),
                    title: const Text("Change Password"),
                  ),
                  ListTile(
                    onTap: () async {
                      bool result = await showConfirmationDialog(
                        context: context,
                        title: 'Log out',
                        content: 'Are you sure you want to log out?',
                      );

                      if (result) {
                        FirebaseAuthHelper.instance.signOut();

                        setState(() {
                          _storeOnboardInfo();
                          Routes.instance.pushAndRemoveUntil(
                              widget: const OnBoarding(),
                              context: context,
                              routeNav: true);
                        });
                      }
                    },
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text("Log out"),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
