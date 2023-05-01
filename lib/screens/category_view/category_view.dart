import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickcart/models/category_model/category_model.dart';
import 'package:quickcart/screens/home/widgets/product_grid.dart';

import '../../constants/asset_images.dart';
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
          : productModelList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AssetsImages.instance.emptyCategory,
                        semanticsLabel: 'No data',
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text("No products yet on this category"),
                      const SizedBox(
                        height: 60,
                      )
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ProductGrid(productList: productModelList)),
                      const SizedBox(
                        height: 12.0,
                      ),
                    ],
                  ),
                ),
    );
  }
}
