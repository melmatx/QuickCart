import 'package:flutter/material.dart';
import 'package:quickcart/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:quickcart/models/order_model/order_model.dart';
import 'package:quickcart/screens/order_screen/widgets/multiple_order_item.dart';
import 'package:quickcart/screens/order_screen/widgets/single_order_item.dart';

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
        stream: Stream.fromFuture(FirebaseFirestoreHelper.instance.getUserOrder(),),
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
            return const Center(
              child: Text("No Order Found"),
            );
          }
          
          return Padding(
            padding: const EdgeInsets.only(bottom:50.0),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              padding: const EdgeInsets.all(12.0),
              itemBuilder: (context, index) {
                OrderModel orderModel = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: orderModel.products.length > 1 ? MultipleOrderItem(orderModel: orderModel) : SingleOrderItem(orderModel: orderModel),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
