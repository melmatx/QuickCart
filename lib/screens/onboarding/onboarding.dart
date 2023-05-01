import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/asset_images.dart';
import '../../constants/routes.dart';
import '../../firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import '../auth_ui/welcome/welcome.dart';
import '../custom_bottom_bar/custom_bottom_bar.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  _storeOnboardInfo() async {
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
  }

  _finishOnBoarding({required BuildContext context}) {
    _storeOnboardInfo();
    Widget home = StreamBuilder(
      stream: FirebaseAuthHelper.instance.getAuthChange,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const CustomBottomBar();
        }

        return const Welcome();
      },
    );
    Routes.instance.pushAndRemoveUntil(widget: home, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      finishButtonText: 'Get Started',
      onFinish: () {
        _finishOnBoarding(context: context);
      },
      finishButtonStyle: const FinishButtonStyle(
        elevation: 20,
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25.0),
          ),
        ),
      ),
      skipFunctionOverride: () {
        _finishOnBoarding(context: context);
      },
      skipTextButton: const Text(
        'Skip',
        style: TextStyle(
          fontSize: 16,
          color: Colors.red,
          fontWeight: FontWeight.w600,
        ),
      ),
      controllerColor: Colors.red,
      totalPage: 3,
      headerBackgroundColor: Colors.white,
      pageBackgroundColor: Colors.white,
      centerBackground: true,
      background: [
        Image.asset(
          AssetsImages.instance.slide_1,
          height: 400,
        ),
        Image.asset(
          AssetsImages.instance.slide_2,
          height: 400,
        ),
        Image.asset(
          AssetsImages.instance.slide_3,
          height: 400,
        ),
      ],
      speed: 1.8,
      pageBodies: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 480,
              ),
              Text(
                'Welcome to QuickCart!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Your seamless shopping experience awaits.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 480,
              ),
              Text(
                "Explore Our Selection",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Find your favorite products in just a few taps.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 480,
              ),
              Text(
                'Fast & Secure Checkout',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Enjoy a hassle-free payment experience.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
