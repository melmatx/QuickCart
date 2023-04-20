import 'package:flutter/material.dart';
import 'package:quickcart/models/category_model/category_model.dart';
import 'package:quickcart/screens/home/widgets/product_card.dart';

import '../../firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import '../../models/product_model/product_model.dart';

class CategoryView extends StatefulWidget {
  final CategoryModel categoryModel;
  const CategoryView({super.key, required this.categoryModel});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  List<ProductModel> productModelList = [];

  bool isLoading = false;
  void getCategoryList() async {
    setState(() {
      isLoading = true;
    });
    productModelList = await FirebaseFirestoreHelper.instance
        .getCategoryViewProduct(widget.categoryModel.id);
    productModelList.shuffle();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getCategoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          widget.categoryModel.name,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: kToolbarHeight),
                  // Padding(
                  //   padding: const EdgeInsets.all(12.0),
                  //   child: Row(
                  //     children: [
                  //       const BackButton(),
                  //       Text(
                  //         widget.categoryModel.name,
                  //         style: const TextStyle(
                  //           fontSize: 18.0,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  productModelList.isEmpty
                      ? const Center(
                          child: Text("Best Product is empty"),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              primary: false,
                              itemCount: productModelList.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 20,
                                      childAspectRatio: 0.7,
                                      crossAxisCount: 2),
                              itemBuilder: (ctx, index) {
                                ProductModel singleProduct =
                                    productModelList[index];
                                return ProductCard(
                                    singleProduct: singleProduct);
                              }),
                        ),
                  const SizedBox(
                    height: 12.0,
                  ),
                ],
              ),
            ),
    );
  }
}
