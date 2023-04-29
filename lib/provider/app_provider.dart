// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:quickcart/constants/constants.dart';
import 'package:quickcart/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:quickcart/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:quickcart/firebase_helper/firebase_storage_helper/firebase_storage_helper.dart';
import 'package:quickcart/models/product_model/product_model.dart';
import 'package:quickcart/models/user_model/user_model.dart';

class AppProvider with ChangeNotifier {
  //// Cart Work
  final List<ProductModel> _cartProductList = [];
  final List<ProductModel> _buyProductList = [];

  UserModel? _userModel;

  UserModel get getUserInformation => _userModel!;

  void addCartProduct(ProductModel productModel) async {
    ProductModel? existingProduct = _cartProductList
        .firstWhereOrNull((element) => element.id == productModel.id);

    if (existingProduct != null) {
      existingProduct.qty = existingProduct.qty! + productModel.qty!;
      await FirebaseFirestoreHelper.instance.updateCartProductQtyInFirebase(
          existingProduct, existingProduct.qty!);
    } else {
      _cartProductList.add(productModel);
      await FirebaseFirestoreHelper.instance
          .addCartProductToFirebase(productModel);
    }

    notifyListeners();
  }

  void removeCartProduct(ProductModel productModel) async {
    ProductModel? existingProduct = _cartProductList
        .firstWhereOrNull((element) => element.id == productModel.id);

    if (existingProduct != null) {
      _cartProductList.remove(existingProduct);

      await FirebaseFirestoreHelper.instance
          .removeCartProductFromFirebase(existingProduct);
    }

    notifyListeners();
  }

  void updateQty(ProductModel productModel, int qty) {
    int index = _cartProductList.indexOf(productModel);
    _cartProductList[index].qty = qty;

    FirebaseFirestoreHelper.instance
        .updateCartProductQtyInFirebase(productModel, qty);

    notifyListeners();
  }

  int getQty(ProductModel productModel) {
    int index = _cartProductList.indexOf(productModel);
    return _cartProductList[index].qty!;
  }

  void getCartProductsFromFirebase() async {
    List<ProductModel> cartProducts =
        await FirebaseFirestoreHelper.instance.getCartProducts();
    _cartProductList.clear();
    _cartProductList.addAll(cartProducts);
    notifyListeners();
  }

  void clearCartProductsFromFirebase() {
    List<ProductModel> cartListCopy = List.from(_cartProductList);

    for (ProductModel productModel in cartListCopy) {
      removeCartProduct(productModel);
    }
  }

  List<ProductModel> get getCartProductList => _cartProductList;

  ///// Favourite ///////
  final List<ProductModel> _favouriteProductList = [];

  void addFavouriteProduct(ProductModel productModel) async {
    _favouriteProductList.add(productModel);

    await FirebaseFirestoreHelper.instance
        .addFavouriteProductToFirebase(productModel);

    notifyListeners();
  }

  void removeFavouriteProduct(ProductModel productModel) async {
    ProductModel existingProduct = _favouriteProductList
        .firstWhere((element) => element.id == productModel.id);

    _favouriteProductList.remove(existingProduct);

    await FirebaseFirestoreHelper.instance
        .removeFavouriteProductFromFirebase(productModel);

    notifyListeners();
  }

  void getFavouriteListFirebase() async {
    List<ProductModel> favoriteList =
        await FirebaseFirestoreHelper.instance.getFavouriteProducts();
    _favouriteProductList.clear();
    _favouriteProductList.addAll(favoriteList);
    notifyListeners();
  }

  void clearFavouriteListFirebase() {
    List<ProductModel> favoriteListCopy = List.from(_favouriteProductList);

    for (ProductModel productModel in favoriteListCopy) {
      removeFavouriteProduct(productModel);
    }
  }

  List<ProductModel> get getFavouriteProductList => _favouriteProductList;

  ////// USer Information
  void getUserInfoFirebase() async {
    _userModel = await FirebaseFirestoreHelper.instance.getUserInformation();
    notifyListeners();
  }

  void updateUserInfoFirebase(
      BuildContext context, UserModel userModel, File? file) async {
    if (file == null) {
      showLoaderDialog(context);

      _userModel = userModel;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userModel!.id)
          .set(_userModel!.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
    } else {
      showLoaderDialog(context);

      String imageUrl =
          await FirebaseStorageHelper.instance.uploadUserImage(file);
      _userModel = userModel.copyWith(image: imageUrl);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userModel!.id)
          .set(_userModel!.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
    }
    await FirebaseAuthHelper.instance.changeEmail(_userModel!.email, context);
    showMessage("Successfully updated profile");

    notifyListeners();
  }

  void removeProfilePictureFirebase(BuildContext context) async {
    showLoaderDialog(context);
    await FirebaseStorageHelper.instance.removeUserImage();
    _userModel = _userModel!.copyWith(image: "");
    await FirebaseFirestore.instance
        .collection("users")
        .doc(_userModel!.id)
        .set(_userModel!.toJson());
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context).pop();
    showMessage("Successfully removed profile picture");
    notifyListeners();
  }

  //////// TOTAL PRICE / // / // / / // / / / // /

  double totalPrice() {
    double totalPrice = 0.0;
    for (var element in _cartProductList) {
      totalPrice += element.price * element.qty!;
    }
    return totalPrice;
  }

  double totalPriceBuyProductList() {
    double shippingFee = 50.0;
    double totalPrice = 0.0;
    for (var element in _buyProductList) {
      totalPrice += element.price * element.qty!;
    }
    return totalPrice + shippingFee;
  }

  ///////// BUY Product  / / // / / // / / / // /

  void addBuyProduct(ProductModel model) {
    _buyProductList.add(model);
    notifyListeners();
  }

  void addBuyProductCartList() {
    _buyProductList.addAll(_cartProductList);
    notifyListeners();
  }

  void clearBuyProduct() {
    _buyProductList.clear();
    notifyListeners();
  }

  List<ProductModel> get getBuyProductList => _buyProductList;
}
