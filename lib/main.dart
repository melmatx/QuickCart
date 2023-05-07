import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:quickcart/constants/constants.dart';
import 'package:quickcart/constants/theme.dart';
import 'package:quickcart/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:quickcart/provider/app_provider.dart';
import 'package:quickcart/screens/auth_ui/welcome/welcome.dart';
import 'package:quickcart/screens/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:quickcart/screens/onboarding/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_helper/firebase_options.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
int? isViewed;

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));
  
  WidgetsFlutterBinding.ensureInitialized();

  // Get Stripe publishable key
  Stripe.publishableKey = "pk_test_51MWx8OAVMyklfe3CsjEzA1CiiY0XBTlHYbZ8jQlGtVFIwQi4aNeGv8J1HUw4rgSavMTLzTwgn0XRlwoTVRFXyu2h00mRUeWmAf";

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Get onboarding status
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.setInt('onBoard', 1);
  isViewed = prefs.getInt('onBoard');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: themeData,
        builder: FToastBuilder(),
        navigatorKey: navigatorKey,
        home: StreamBuilder(
          stream: FirebaseAuthHelper.instance.getAuthChange,
          builder: (context, snapshot) {
            if (isViewed != 0) {
              return const OnBoarding();
            }

            if (snapshot.hasData && (snapshot.data!.emailVerified)) {
                return const CustomBottomBar();
            }

            return const Welcome();
          },
        ),
      ),
    );
  }
}
