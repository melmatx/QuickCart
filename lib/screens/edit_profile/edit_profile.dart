import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quickcart/constants/constants.dart';
import 'package:quickcart/models/user_model/user_model.dart';
import 'package:quickcart/widgets/primary_button/primary_button.dart';

import '../../provider/app_provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? image;
  void takePicture() async {
    XFile? value = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 40);
    if (value != null) {
      setState(() {
        image = File(value.path);
      });
    }
  }

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          image == null
              ? CupertinoButton(
                  onPressed: () {
                    takePicture();
                  },
                  child: const CircleAvatar(
                      radius: 55, child: Icon(Icons.camera_alt)),
                )
              : CupertinoButton(
                  onPressed: () {
                    takePicture();
                  },
                  child: CircleAvatar(
                    backgroundImage: FileImage(image!),
                    radius: 55,
                  ),
                ),
          const SizedBox(
            height: 12.0,
          ),
          TextFormField(
            controller: name,
            decoration: InputDecoration(
              hintText: appProvider.getUserInformation.name,
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          TextFormField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: appProvider.getUserInformation.email,
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          TextFormField(
            controller: phone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: appProvider.getUserInformation.phone,
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          TextFormField(
            controller: address,
            keyboardType: TextInputType.streetAddress,
            decoration: InputDecoration(
              hintText: appProvider.getUserInformation.address,
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          PrimaryButton(
            title: "Update",
            onPressed: () async {
              bool isVaildated = editProfileValidation(
                  name: name.text,
                  email: email.text,
                  phone: phone.text,
                  address: address.text
              );
              if (isVaildated || image != null) {
                UserModel userModel = appProvider.getUserInformation.copyWith(
                    name: name.text.isEmpty
                        ? appProvider.getUserInformation.name
                        : name.text,
                    email: email.text.isEmpty
                        ? appProvider.getUserInformation.email
                        : email.text,
                    phone: phone.text.isEmpty
                        ? appProvider.getUserInformation.phone
                        : phone.text,
                    address: address.text.isEmpty
                        ? appProvider.getUserInformation.address
                        : address.text);
                appProvider.updateUserInfoFirebase(context, userModel, image);
              }
            },
          ),
        ],
      ),
    );
  }
}
