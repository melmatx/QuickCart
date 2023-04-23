import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      bottomNavigationBar: SizedBox(
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
                    "\$${appProvider.totalPrice().toString()}",
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
                            widget: const CartItemCheckout(), context: context);
                      },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        // backgroundColor: Colo,
        title: const Text(
          "Cart Screen",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          appProvider.getCartProductList.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      appProvider.clearCartProductsFromFirebase();
                      showMessage("Cart Cleared!");
                    });
                  },
                  icon: const Icon(Icons.delete_sweep_sharp),
                )
              : const IconButton(
                  onPressed: null, icon: Icon(Icons.delete_sweep_outlined))
        ],
      ),
      body: appProvider.getCartProductList.isEmpty
          ? const Center(
              child: Text("Empty"),
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
