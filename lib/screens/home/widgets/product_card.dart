import 'package:flutter/material.dart';
import 'package:quickcart/constants/routes.dart';
import 'package:quickcart/models/product_model/product_model.dart';
import 'package:quickcart/screens/product_details/product_details.dart';

class ProductCard extends StatelessWidget {
  final ProductModel singleProduct;

  const ProductCard({super.key, required this.singleProduct});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 12.0,
          ),
          Image.network(
            singleProduct.image,
            height: 100,
            width: 100,
          ),
          const SizedBox(
            height: 12.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              singleProduct.name,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Text("Price: \$${singleProduct.price}"),
          const SizedBox(
            height: 30.0,
          ),
          SizedBox(
            height: 45,
            width: 140,
            child: OutlinedButton(
              onPressed: () {
                Routes.instance.push(
                    widget: ProductDetails(singleProduct: singleProduct),
                    context: context);
              },
              child: const Text(
                "Buy",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
