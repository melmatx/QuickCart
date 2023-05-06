import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickcart/constants/routes.dart';
import 'package:quickcart/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:quickcart/models/product_model/product_model.dart';
import 'package:quickcart/screens/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:quickcart/widgets/primary_button/primary_button.dart';

import '../../provider/app_provider.dart';
import '../../stripe_helper/stripe_helper.dart';

class Checkout extends StatefulWidget {
  final ProductModel singleProduct;
  const Checkout({super.key, required this.singleProduct});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  int groupValue = 1;
  bool buttonClicked = false;
  double shippingFee = 0.0;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Checkout",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "User Information",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 12.0,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 3.0)),
                padding: const EdgeInsets.all(12.0),
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person),
                          const SizedBox(width: 8.0),
                          Text(appProvider.getUserInformation.name),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.email),
                          const SizedBox(width: 8.0),
                          Text(appProvider.getUserInformation.email),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.phone),
                          const SizedBox(width: 8.0),
                          Text(appProvider.getUserInformation.phone),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on),
                          const SizedBox(width: 8.0),
                          Text(appProvider.getUserInformation.address),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              const Text(
                "Payment Options",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 12.0,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 3.0)),
                width: double.infinity,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Radio(
                            value: 1,
                            groupValue: groupValue,
                            onChanged: (value) {
                              setState(() {
                                groupValue = value!;
                              });
                            },
                          ),
                          const Icon(Icons.money),
                          const SizedBox(
                            width: 12.0,
                          ),
                          const Text(
                            "Cash on Delivery",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Radio(
                            value: 2,
                            groupValue: groupValue,
                            onChanged: (value) {
                              setState(() {
                                groupValue = value!;
                              });
                            },
                          ),
                          const Icon(Icons.account_balance),
                          const SizedBox(
                            width: 12.0,
                          ),
                          const Text(
                            "Pay Online",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    shippingFee == 0.0
                        ? "-"
                        : "₱${widget.singleProduct.price % 1 == 0 ? (widget.singleProduct.price + shippingFee).round().toString() : (widget.singleProduct.price + shippingFee).toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 2.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Order Total",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    "₱${widget.singleProduct.price % 1 == 0 ? widget.singleProduct.price.round().toString() : widget.singleProduct.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Shipping Fee",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    "₱${shippingFee % 1 == 0 ? shippingFee.round().toString() : shippingFee.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40.0,
              ),
              PrimaryButton(
                title: "Confirm Payment",
                onPressed: buttonClicked
                    ? null
                    : () async {
                        setState(() {
                          buttonClicked = true;
                        });
                        appProvider.clearBuyProduct();
                        appProvider.addBuyProduct(widget.singleProduct);

                        if (groupValue == 1) {
                          bool value = await FirebaseFirestoreHelper.instance
                              .uploadOrderedProductFirebase(
                                  appProvider.getBuyProductList,
                                  context,
                                  "Cash on delivery");

                          if (value) {
                            Future.delayed(const Duration(seconds: 1), () {
                              appProvider.clearBuyProduct();
                              Routes.instance.pushAndRemoveUntil(
                                  widget: const CustomBottomBar(),
                                  context: context,
                                  material: false);
                            });
                          }
                        } else {
                          String totalPrice =
                              (appProvider.totalPriceBuyProductList() * 10)
                                  .toString()
                                  .replaceAll('.', '');
                          await StripeHelper.instance
                              .makePayment(totalPrice, context,
                                  onPaymentResult: (isButtonClicked) {
                            setState(() {
                              buttonClicked = isButtonClicked;
                            });
                          });
                        }
                      },
              )
            ],
          ),
        ),
      ),
    );
  }
}
