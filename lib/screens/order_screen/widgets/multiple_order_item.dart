import 'package:flutter/material.dart';
import 'package:quickcart/models/order_model/order_model.dart';

class MultipleOrderItem extends StatelessWidget {
  final OrderModel orderModel;

  const MultipleOrderItem({super.key, required this.orderModel});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      collapsedShape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).primaryColor, width: 2.3)),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).primaryColor, width: 2.3)),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            height: 142,
            width: 120,
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            child: Image.network(
              orderModel.products[0].image,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.38,
                  child: Text(
                    "${orderModel.products[0].name.split(' ')[0]} and ${orderModel.products.length - 1} more...",
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Column(
                  children: [
                    Text(
                      "Products in Cart: ${orderModel.products.length.toString()}",
                      style: const TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                  ],
                ),
                Text(
                  "Total Price: ₱${orderModel.totalPrice % 1 == 0 ? orderModel.totalPrice.round().toString() : orderModel.totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Text(
                  "Order Status: ${orderModel.status}",
                  style: const TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Text(
                  "Date: ${orderModel.createdAt.toDate().toString().substring(0, 10)}",
                  style: const TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      children: orderModel.products.length > 1
          ? [
              Container(
                height: 1.0,
                decoration: BoxDecoration(
                  color: Colors.grey[250],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6.5,
                      spreadRadius: 1.5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              const Text("Details"),
              Divider(
                  color: Theme.of(context).primaryColor,
                  thickness: 1,
                  indent: 8,
                  endIndent: 8),
              ...orderModel.products.map((singleProduct) {
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 12.0, top: 6.0, bottom: 6.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.5),
                            child: Image.network(
                              singleProduct.image,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  singleProduct.name,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 12.0,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Quanity: ${singleProduct.qty.toString()}",
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12.0,
                                    ),
                                  ],
                                ),
                                Text(
                                  "Price: ₱${singleProduct.price % 1 == 0 ? singleProduct.price.round().toString() : singleProduct.price.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList()
            ]
          : [],
    );
  }
}
