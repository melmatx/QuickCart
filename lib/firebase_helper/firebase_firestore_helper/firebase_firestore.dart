// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:quickcart/constants/constants.dart';
import 'package:quickcart/models/category_model/category_model.dart';
import 'package:quickcart/models/order_model/order_model.dart';
import 'package:quickcart/models/product_model/product_model.dart';
import 'package:quickcart/models/user_model/user_model.dart';

class FirebaseFirestoreHelper {
  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<CategoryModel>> getCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection("categories").get();

      List<CategoryModel> categoriesList = querySnapshot.docs
          .map((e) => CategoryModel.fromJson(e.data()))
          .toList();

      return categoriesList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> getAllProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collectionGroup("products").get();

      List<ProductModel> productModelList = querySnapshot.docs
          .map((e) => ProductModel.fromJson(e.data()))
          .toList();

      return productModelList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> getCategoryViewProduct(String id) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("categories")
              .doc(id)
              .collection("products")
              .get();

      List<ProductModel> productModelList = querySnapshot.docs
          .map((e) => ProductModel.fromJson(e.data()))
          .toList();

      return productModelList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<UserModel> getUserInformation() async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

    return UserModel.fromJson(querySnapshot.data()!);
  }

  Future<bool> uploadOrderedProductFirebase(
      List<ProductModel> list, BuildContext context, String payment,
      {double shipping = 0.0}) async {
    try {
      showLoaderDialog(context);
      double totalPrice = 0.0;
      for (var element in list) {
        totalPrice += element.price * element.qty!;
      }
      totalPrice += shipping;
      DocumentReference documentReference = _firebaseFirestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("orders")
          .doc();
      DocumentReference admin =
          _firebaseFirestore.collection("usersOrders").doc();

      admin.set({
        "products": list.map((e) => e.toJson()),
        "status": "Pending",
        "totalPrice": totalPrice,
        "payment": payment,
        "orderId": admin.id,
        "createdAt": FieldValue.serverTimestamp(),
      });
      documentReference.set({
        "products": list.map((e) => e.toJson()),
        "status": "Pending",
        "totalPrice": totalPrice,
        "payment": payment,
        "orderId": documentReference.id,
        "createdAt": FieldValue.serverTimestamp(),
      });
      Navigator.of(context, rootNavigator: true).pop();
      showMessage("Ordered Successfully");
      return true;
    } catch (e) {
      showMessage(e.toString());
      Navigator.of(context, rootNavigator: true).pop();
      return false;
    }
  }

  ////// Get Order User//////

  Future<List<OrderModel>> getUserOrder() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("orders")
              .orderBy("createdAt", descending: true)
              .get();

      List<OrderModel> orderList = querySnapshot.docs
          .map((element) => OrderModel.fromJson(element.data()))
          .toList();

      return orderList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  // void updateTokenFromFirebase() async {
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   if (token != null) {
  //     await _firebaseFirestore
  //         .collection("users")
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .update({
  //       "notificationToken": token,
  //     });
  //   }
  // }

  Future<void> addFavouriteProductToFirebase(ProductModel productModel) async {
    try {
      await _firebaseFirestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("favourites")
          .doc(productModel.id)
          .set(productModel.copyWith(dateAdded: Timestamp.now()).toJson());
    } catch (e) {
      showMessage(e.toString());
    }
  }

  Future<void> removeFavouriteProductFromFirebase(
      ProductModel productModel) async {
    try {
      await _firebaseFirestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("favourites")
          .doc(productModel.id)
          .delete();
    } catch (e) {
      showMessage(e.toString());
    }
  }

  Future<List<ProductModel>> getFavouriteProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("favourites")
              .orderBy("dateAdded", descending: false)
              .get();

      List<ProductModel> favouriteProductsList = querySnapshot.docs
          .map((e) => ProductModel.fromJson(e.data()))
          .toList();

      return favouriteProductsList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<void> addCartProductToFirebase(ProductModel productModel) async {
    try {
      await _firebaseFirestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("cart")
          .doc(productModel.id)
          .set(productModel.copyWith(dateAdded: Timestamp.now()).toJson());
    } catch (e) {
      showMessage(e.toString());
    }
  }

  Future<void> removeCartProductFromFirebase(ProductModel productModel) async {
    try {
      await _firebaseFirestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("cart")
          .doc(productModel.id)
          .delete();
    } catch (e) {
      showMessage(e.toString());
    }
  }

  Future<List<ProductModel>> getCartProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("cart")
              .orderBy("dateAdded", descending: false)
              .get();

      List<ProductModel> cartProductsList = querySnapshot.docs
          .map((e) => ProductModel.fromJson(e.data()))
          .toList();

      return cartProductsList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<void> updateCartProductQtyInFirebase(
      ProductModel productModel, int qty) async {
    try {
      await _firebaseFirestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("cart")
          .doc(productModel.id)
          .update({"qty": qty});
    } catch (e) {
      showMessage(e.toString());
    }
  }
}
