import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickcart/models/product_model/product_model.dart';
import 'package:quickcart/provider/app_provider.dart';
import 'package:quickcart/screens/product_details/product_details.dart';

import '../../../constants/constants.dart';
import '../../../constants/routes.dart';

class SingleFavouriteItem extends StatefulWidget {
  final ProductModel singleProduct;
  const SingleFavouriteItem({super.key, required this.singleProduct});

  @override
  State<SingleFavouriteItem> createState() => _SingleFavouriteItemState();
}

class _SingleFavouriteItemState extends State<SingleFavouriteItem> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          12,
        ),
        border: Border.all(color: Theme.of(context).primaryColor, width: 3),
      ),
      child: InkWell(
        onTap: () {
          Routes.instance.push(
              widget: ProductDetails(singleProduct: widget.singleProduct),
              context: context);
        },
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(6),
                height: 140,
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                child: Image.network(
                  widget.singleProduct.image,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 140,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.38,
                                child: Text(
                                  widget.singleProduct.name,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                height: 9,
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  if (!appProvider.getCartProductList.any(
                                      (element) =>
                                          element.id ==
                                          widget.singleProduct.id)) {
                                    appProvider.addCartProduct(
                                        widget.singleProduct.copyWith(qty: 1));
                                    showMessage("Added to Cart");
                                  } else {
                                    appProvider.removeCartProduct(
                                        widget.singleProduct);
                                    showMessage("Removed from Cart");
                                  }
                                },
                                child: Text(
                                  appProvider.getCartProductList.any(
                                          (element) =>
                                              element.id ==
                                              widget.singleProduct.id)
                                      ? "Remove from Cart"
                                      : "Add to Cart",
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  AppProvider appProvider =
                                      Provider.of<AppProvider>(context,
                                          listen: false);
                                  appProvider.removeFavouriteProduct(
                                      widget.singleProduct);
                                  showMessage("Removed from wishlist");
                                },
                                child: const Text(
                                  "Remove from wishlist",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 55,
                            child: AutoSizeText(
                              textAlign: TextAlign.right,
                              "₱${widget.singleProduct.price % 1 == 0 ? widget.singleProduct.price.round().toString() : widget.singleProduct.price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
