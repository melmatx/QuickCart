import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickcart/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:quickcart/models/order_model/order_model.dart';
import 'package:quickcart/screens/order_screen/widgets/multiple_order_item.dart';
import 'package:quickcart/screens/order_screen/widgets/single_order_item.dart';

import '../../constants/asset_images.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Your Orders",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: Stream.fromFuture(
          FirebaseFirestoreHelper.instance.getUserOrder(),
        ),
        // future: FirebaseFirestoreHelper.instance.getUserOrder(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.isEmpty ||
              snapshot.data == null ||
              !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AssetsImages.instance.emptyOrders,
                    semanticsLabel: 'Empty orders',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text("No orders yet"),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            padding: const EdgeInsets.all(12.0),
            itemBuilder: (context, index) {
              OrderModel orderModel = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: orderModel.products.length > 1
                    ? MultipleOrderItem(orderModel: orderModel)
                    : SingleOrderItem(orderModel: orderModel),
              );
            },
          );
        },
      ),
    );
  }
}
