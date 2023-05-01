import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickcart/models/product_model/product_model.dart';
import 'package:quickcart/provider/app_provider.dart';
import 'package:quickcart/screens/product_details/product_details.dart';

import '../../../constants/constants.dart';
import '../../../constants/routes.dart';

class SingleCartItem extends StatefulWidget {
  final ProductModel singleProduct;
  const SingleCartItem({super.key, required this.singleProduct});

  @override
  State<SingleCartItem> createState() => _SingleCartItemState();
}

class _SingleCartItemState extends State<SingleCartItem> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    
    int qty = appProvider.getQty(widget.singleProduct);
    widget.singleProduct.isFavourite = appProvider.getFavouriteProductList
        .any((element) => element.id == widget.singleProduct.id);

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
                width: 120,
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
                                child: AutoSizeText(
                                  widget.singleProduct.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  CupertinoButton(
                                    onPressed: () {
                                      if (qty > 1) {
                                        setState(() {
                                          qty--;
                                        });
                                        appProvider.updateQty(
                                            widget.singleProduct, qty);
                                      } else {
                                        appProvider.removeCartProduct(
                                            widget.singleProduct);
                                        showMessage("Removed from Cart");
                                      }
                                    },
                                    padding: EdgeInsets.zero,
                                    child: const CircleAvatar(
                                      maxRadius: 13,
                                      child: Icon(Icons.remove),
                                    ),
                                  ),
                                  Text(
                                    qty.toString(),
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  CupertinoButton(
                                    onPressed: () {
                                      setState(() {
                                        qty++;
                                      });
                                      appProvider.updateQty(
                                          widget.singleProduct, qty);
                                    },
                                    padding: EdgeInsets.zero,
                                    child: const CircleAvatar(
                                      maxRadius: 13,
                                      child: Icon(Icons.add),
                                    ),
                                  ),
                                ],
                              ),
                              CupertinoButton(
                                padding:
                                    const EdgeInsets.only(left: 3.0, top: 3.0),
                                onPressed: () {
                                  if (!widget.singleProduct.isFavourite) {
                                    appProvider.addFavouriteProduct(
                                        widget.singleProduct);
                                    showMessage("Added to wishlist");
                                  } else {
                                    appProvider.removeFavouriteProduct(
                                        widget.singleProduct);
                                    showMessage("Removed from wishlist");
                                  }
                                },
                                child: Text(
                                  widget.singleProduct.isFavourite
                                      ? "Remove from wishlist"
                                      : "Add to wishlist",
                                  style: const TextStyle(
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
                      CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            appProvider.removeCartProduct(widget.singleProduct);
                            showMessage("Removed from Cart");
                          },
                          child: const CircleAvatar(
                            maxRadius: 13,
                            child: Icon(
                              Icons.delete,
                              size: 17,
                            ),
                          )),
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
