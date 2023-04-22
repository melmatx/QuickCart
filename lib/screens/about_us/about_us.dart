import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: Colo,
        title: const Text(
          "About Us",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 15.0),
        child: Text(
            "Founded in 2023 by a team of four talented Computer Science students, Wyndelle Cordova, Clint Claro, Jeffrey Mamac, and Mel Mathew Palaña, QuickCart is an online ordering system that revolutionizes the way customers shop and purchase products online. As avid fans of online shopping, the researchers noticed that many online ordering systems were difficult to navigate, leading to frustration and wasted time for customers. Determined to create a solution, the four students came together to develop an online ordering system that was user-friendly, efficient, and fast. They envisioned a platform that would offer a wide range of products from various merchants, providing customers with a convenient and hassle-free shopping experience and thus QuickCart was born."),
      ),
    );
  }
}
