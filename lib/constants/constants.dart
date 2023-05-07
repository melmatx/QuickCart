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

bool loginValidation(String email, String password) {
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

bool signUpValidation(String email, String password, String confirmPass,
    String name, String phone, String address) {
  removeToastQueues();

  // Checks if phone is all digits but can include + though it is not required
  RegExp phoneRegex = RegExp(r'^[0-9+]*$');

  if (email.isEmpty &&
      password.isEmpty &&
      confirmPass.isEmpty &&
      name.isEmpty &&
      phone.isEmpty &&
      address.isEmpty) {
    showMessage("All Fields are empty", isTop: false);
    return false;
  }

  if (name.isEmpty) {
    showMessage("Name is Empty", isTop: false);
    return false;
  }

  if (email.isEmpty) {
    showMessage("Email is Empty", isTop: false);
    return false;
  }

  if (phone.isEmpty) {
    showMessage("Phone is Empty", isTop: false);
    return false;
  }

  if (password.isEmpty) {
    showMessage("Password is Empty", isTop: false);
    return false;
  }

  if (address.isEmpty) {
    showMessage("Address is Empty", isTop: false);
    return false;
  }

  if (password != confirmPass) {
    showMessage("Passwords are not the same", isTop: false);
    return false;
  }

  if (!phoneRegex.hasMatch(phone) || phone.length < 10) {
    showMessage("Phone number is not valid", isTop: false);
    return false;
  }

  if (address.length < 10) {
    showMessage("Address is too short", isTop: false);
    return false;
  }

  return true;
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

String extractErrorMessage(String error) {
  return error.toString().split("Firebase:")[1].split("(")[0].trim();
}
