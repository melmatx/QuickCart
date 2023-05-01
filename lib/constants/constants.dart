import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickcart/main.dart';

String appName = "QuickCart";

void showMessage(String message, {isTop = true}) {
  FToast fToast = FToast();
  fToast.init(navigatorKey.currentContext!);
  fToast.showToast(
    child: Container(
      margin: !isTop ? const EdgeInsets.only(top: 124) : null,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.red.withOpacity(0.90),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    ),
    gravity: isTop ? ToastGravity.TOP : ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 2),
  );
}

void removeToastQueues() {
  FToast fToast = FToast();
  fToast.removeQueuedCustomToasts();
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Builder(builder: (context) {
      return SizedBox(
        width: 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: Color(0xffe16555),
            ),
            const SizedBox(
              height: 18.0,
            ),
            Container(
                margin: const EdgeInsets.only(left: 7),
                child: const Text("Loading...")),
          ],
        ),
      );
    }),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
  return result ?? false;
}

String getMessageFromErrorCode(String errorCode) {
  switch (errorCode) {
    case "ERROR_EMAIL_ALREADY_IN_USE":
      return "Email already used. Go to login page.";
    case "account-exists-with-different-credential":
      return "Email already used. Go to login page.";
    case "email-already-in-use":
      return "Email already used. Go to login page.";
    case "ERROR_WRONG_PASSWORD":
    case "wrong-password":
      return "Wrong Password ";
    case "ERROR_USER_NOT_FOUND":
      return "No user found with this email.";
    case "user-not-found":
      return "No user found with this email.";
    case "ERROR_USER_DISABLED":
      return "User disabled.";
    case "user-disabled":
      return "User disabled.";
    case "ERROR_TOO_MANY_REQUESTS":
      return "Too many requests to log/register into this account.";
    case "operation-not-allowed":
      return "Too many requests to log/register into this account.";
    case "ERROR_OPERATION_NOT_ALLOWED":
      return "Too many requests to log/register into this account.";
    case "ERROR_INVALID_EMAIL":
      return "Email address is invalid.";
    case "invalid-email":
      return "Email address is invalid.";
    default:
      return "Login/Register failed. Please try again. ($errorCode)";
  }
}

bool loginVaildation(String email, String password) {
  removeToastQueues();
  if (email.isEmpty && password.isEmpty) {
    showMessage("Both Fields are empty", isTop: false);
    return false;
  } else if (email.isEmpty) {
    showMessage("Email is Empty", isTop: false);
    return false;
  } else if (password.isEmpty) {
    showMessage("Password is Empty", isTop: false);
    return false;
  } else {
    return true;
  }
}

bool signUpVaildation(String email, String password, String confirmPass,
    String name, String phone, String address) {
  removeToastQueues();
  if (email.isEmpty &&
      password.isEmpty &&
      name.isEmpty &&
      phone.isEmpty &&
      address.isEmpty) {
    showMessage("All Fields are empty", isTop: false);
    return false;
  } else if (name.isEmpty) {
    showMessage("Name is Empty", isTop: false);
    return false;
  } else if (email.isEmpty) {
    showMessage("Email is Empty", isTop: false);
    return false;
  } else if (phone.isEmpty) {
    showMessage("Phone is Empty", isTop: false);
    return false;
  } else if (password.isEmpty) {
    showMessage("Password is Empty", isTop: false);
    return false;
  } else if (address.isEmpty) {
    showMessage("Address is Empty", isTop: false);
    return false;
  } else if (password != confirmPass) {
    showMessage("Passwords are not the same", isTop: false);
    return false;
  } else {
    return true;
  }
}

bool editProfileValidation(
    {String? email,
    String? password,
    String? name,
    String? phone,
    String? address,
    File? image}) {
  bool isEmailEmpty = email == null || email.isEmpty;
  bool isNameEmpty = name == null || name.isEmpty;
  bool isPhoneEmpty = phone == null || phone.isEmpty;
  bool isAddressEmpty = address == null || address.isEmpty;

  if (isEmailEmpty &&
      isNameEmpty &&
      isPhoneEmpty &&
      isAddressEmpty &&
      image == null) {
    return false;
  }

  return true;
}
