import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quickcart/constants/asset_images.dart';
import 'package:quickcart/constants/constants.dart';
import 'package:quickcart/screens/cart_item_checkout/cart_item_checkout.dart';
import 'package:quickcart/screens/cart_screen/widgets/single_cart_item.dart';

import '../../constants/routes.dart';
import '../../provider/app_provider.dart';
import '../../widgets/primary_button/primary_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );

    return Scaffold(
      bottomNavigationBar: appProvider.getCartProductList.isNotEmpty
          ? SizedBox(
              height: 180,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
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
                          "₱${appProvider.totalPrice() % 1 == 0 ? appProvider.totalPrice().round().toString() : appProvider.totalPrice().toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    PrimaryButton(
                      title: "Checkout",
                      onPressed: appProvider.getCartProductList.isEmpty
                          ? null
                          : () {
                              Routes.instance.push(
                                  widget: const CartItemCheckout(),
                                  context: context);
                            },
                    ),
                  ],
                ),
              ),
            )
          : null,
      appBar: AppBar(
        // backgroundColor: Colo,
        title: const Text(
          "Cart Screen",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          if (appProvider.getCartProductList.isNotEmpty)
            IconButton(
              onPressed: () async {
                bool result = await showConfirmationDialog(
                  context: context,
                  title: 'Clear Cart',
                  content: 'Are you sure you want to clear all cart items?',
                );
                if (result) {
                  setState(() {
                    appProvider.clearCartProductsFromFirebase();
                    showMessage("Cart Cleared!");
                  });
                }
              },
              icon: const Icon(Icons.delete_sweep_outlined),
            )
        ],
      ),
      body: appProvider.getCartProductList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AssetsImages.instance.emptyCart,
                    semanticsLabel: 'Empty cart',
                    width: 150,
                    height: 155,
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  const Text("Cart is Empty!"),
                  const SizedBox(
                    height: 60,
                  )
                ],
              ),
            )
          : ListView.builder(
              itemCount: appProvider.getCartProductList.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (ctx, index) {
                return SingleCartItem(
                  singleProduct: appProvider.getCartProductList[index],
                );
              }),
    );
  }
}
