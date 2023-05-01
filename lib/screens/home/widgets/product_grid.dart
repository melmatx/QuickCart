import 'package:flutter/material.dart';

import '../../../models/product_model/product_model.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<ProductModel> productList;

  const ProductGrid({super.key, required this.productList});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double screenWidth = MediaQuery.of(context).size.width;

        // Calculate the crossAxisCount based on screen width
        int crossAxisCount = screenWidth ~/ 200;
        crossAxisCount = crossAxisCount >= 2 ? crossAxisCount : 2;

        return GridView.builder(
          padding: const EdgeInsets.only(bottom: 50),
          shrinkWrap: true,
          primary: false,
          itemCount: productList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.62,
            crossAxisCount: crossAxisCount,
          ),
          itemBuilder: (ctx, index) {
            ProductModel singleProduct = productList[index];
            return ProductCard(singleProduct: singleProduct);
          },
        );
      },
    );
  }
}
