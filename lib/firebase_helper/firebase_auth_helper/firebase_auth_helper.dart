// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickcart/constants/constants.dart';
import 'package:quickcart/constants/routes.dart';
import 'package:quickcart/models/user_model/user_model.dart';
import 'package:quickcart/screens/auth_ui/login/login.dart';
import 'package:quickcart/screens/auth_ui/welcome/welcome.dart';

class FirebaseAuthHelper {
  static FirebaseAuthHelper instance = FirebaseAuthHelper();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<User?> get getAuthChange => _auth.authStateChanges();

  Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      showLoaderDialog(context);
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;

      if (user == null) {
        return false;
      }

      if (user.emailVerified) {
        Navigator.of(context, rootNavigator: true).pop();
        return true;
      } else if (!user.emailVerified) {
        try {
          await user.sendEmailVerification();
          Navigator.of(context).pop();
          showMessage(
              "Your email address has not been verified. Please check your inbox.",
              isTop: false);
        } catch (error) {
          Navigator.of(context).pop();
          debugPrint(error.toString());
          showMessage(extractErrorMessage(error.toString()), isTop: false);
        }
      }

      return false;
    } on FirebaseAuthException catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      showMessage(extractErrorMessage(error.message!), isTop: false);
      debugPrint(error.toString());
      return false;
    }
  }

  Future signUp(String name, String email, String password, String phone,
      String address, BuildContext context) async {
    try {
      showLoaderDialog(context);
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        await user.sendEmailVerification();
        signOut();

        UserModel userModel = UserModel(
            id: userCredential.user!.uid,
            name: name,
            email: email,
            phone: phone,
            address: address,
            image: null);

        _firestore
            .collection("users")
            .doc(userModel.id)
            .set(userModel.toJson());

        Navigator.of(context, rootNavigator: true).pop();
        showMessage(
            "Email verification sent. Please verify your email first before logging in.",
            isTop: false);
        Routes.instance.pushAndRemoveUntil(
            widget: const Welcome(), context: context, routeNav: true);
        Routes.instance.push(widget: const Login(), context: context);
      }
    } on FirebaseAuthException catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      showMessage(extractErrorMessage(error.message!), isTop: false);
      debugPrint(error.toString());
    }
  }

  Future<bool> changePassword(String password, BuildContext context) async {
    try {
      showLoaderDialog(context);
      await _auth.currentUser!.updatePassword(password);
      // UserCredential userCredential = await _auth
      //     .createUserWithEmailAndPassword(email: email, password: password);
      // UserModel userModel = UserModel(
      //     id: userCredential.user!.uid, name: name, email: email, image: null);

      // _firestore.collection("users").doc(userModel.id).set(userModel.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      showMessage("Password Changed");
      Navigator.of(context).pop();

      return true;
    } on FirebaseAuthException catch (error) {
      Navigator.of(context).pop();
      showMessage(extractErrorMessage(error.message!), isTop: false);
      debugPrint(error.toString());
      return false;
    }
  }

  Future<bool> changeEmail(String email, BuildContext context) async {
    try {
      await _auth.currentUser!.updateEmail(email);

      return true;
    } on FirebaseAuthException catch (error) {
      Navigator.of(context).pop();
      showMessage(extractErrorMessage(error.message!), isTop: false);
      debugPrint(error.toString());
      return false;
    }
  }

  void signOut() async {
    await _auth.signOut();
  }
}
