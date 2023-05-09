import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickcart/constants/constants.dart';
import 'package:quickcart/constants/routes.dart';
import 'package:quickcart/models/product_model/product_model.dart';
import 'package:quickcart/provider/app_provider.dart';
import 'package:quickcart/screens/cart_screen/cart_screen.dart';

import '../check_out/check_out.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel singleProduct;
  const ProductDetails({super.key, required this.singleProduct});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int qty = 1;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    widget.singleProduct.isFavourite = appProvider.getFavouriteProductList
        .any((element) => element.id == widget.singleProduct.id);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Routes.instance
                  .push(widget: const CartScreen(), context: context);
            },
            icon: const Icon(Icons.shopping_cart),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  widget.singleProduct.image,
                  height: 400,
                  width: 400,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.singleProduct.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.singleProduct.isFavourite =
                            !widget.singleProduct.isFavourite;
                      });
                      if (widget.singleProduct.isFavourite) {
                        appProvider.addFavouriteProduct(widget.singleProduct);
                        removeToastQueues();
                        showMessage("Added to Wishlist");
                      } else {
                        appProvider
                            .removeFavouriteProduct(widget.singleProduct);
                        removeToastQueues();
                        showMessage("Removed from Wishlist");
                      }
                    },
                    icon: Icon(widget.singleProduct.isFavourite
                        ? Icons.favorite
                        : Icons.favorite_border),
                  ),
                ],
              ),
              Text(
                "₱${widget.singleProduct.price % 1 == 0 ? widget.singleProduct.price.round().toString() : widget.singleProduct.price.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 12.0,
              ),
              Text(widget.singleProduct.description),
              const SizedBox(
                height: 32.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton(
                    onPressed: () {
                      if (qty > 1) {
                        setState(() {
                          qty--;
                        });
                      }
                    },
                    padding: EdgeInsets.zero,
                    child: const CircleAvatar(
                      child: Icon(Icons.remove),
                    ),
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  Text(
                    qty.toString(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      setState(() {
                        qty++;
                      });
                    },
                    padding: EdgeInsets.zero,
                    child: const CircleAvatar(
                      child: Icon(Icons.add),
                    ),
                  ),
                ],
              ),
              // const Spacer(),
              const SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 39,
                    width: 140,
                    child: OutlinedButton(
                      onPressed: () {
                        ProductModel productModel =
                            widget.singleProduct.copyWith(qty: qty);
                        appProvider.addCartProduct(productModel);
                        removeToastQueues();
                        showMessage("Added to Cart");
                      },
                      child: const Text("ADD TO CART"),
                    ),
                  ),
                  const SizedBox(
                    width: 24.0,
                  ),
                  SizedBox(
                    height: 38,
                    width: 140,
                    child: ElevatedButton(
                      onPressed: () {
                        ProductModel productModel =
                            widget.singleProduct.copyWith(qty: qty);
                        Routes.instance.push(
                            widget: Checkout(singleProduct: productModel),
                            context: context);
                      },
                      child: const Text("BUY"),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
