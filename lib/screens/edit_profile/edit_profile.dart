// ignore_for_file: use_build_context_synchronously

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
  final ValueNotifier<bool> _isValid = ValueNotifier<bool>(false);

  void takePicture() async {
    XFile? value = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 40);
    if (value != null) {
      setState(() {
        image = File(value.path);
        validateInputs();
      });
    }
  }

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();

  void validateInputs() {
    _isValid.value = editProfileValidation(
        name: name.text,
        email: email.text,
        phone: phone.text,
        address: address.text,
        image: image);
  }

  @override
  void initState() {
    super.initState();
    name.addListener(validateInputs);
    email.addListener(validateInputs);
    phone.addListener(validateInputs);
    address.addListener(validateInputs);
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    address.dispose();
    _isValid.dispose();
    super.dispose();
  }

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
          CupertinoButton(
            onPressed: () {
              takePicture();
            },
            padding: EdgeInsets.zero,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (image != null)
                  CircleAvatar(
                    backgroundImage: FileImage(image!),
                    radius: 55,
                  )
                else if (appProvider.getUserInformation.image != null &&
                    appProvider.getUserInformation.image!.isNotEmpty)
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage(appProvider.getUserInformation.image!),
                    radius: 55,
                  ),
                if (image == null &&
                    (appProvider.getUserInformation.image == null ||
                        appProvider.getUserInformation.image!.isEmpty))
                  const Opacity(
                    opacity: 1,
                    child: CircleAvatar(
                      radius: 55,
                      child: Icon(Icons.camera_alt),
                    ),
                  )
                else
                  const Opacity(
                    opacity: 0.8,
                    child: CircleAvatar(
                      radius: 55,
                      child: Icon(Icons.camera_alt),
                    ),
                  )
              ],
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
          ValueListenableBuilder<bool>(
            valueListenable: _isValid,
            builder: (context, isValid, _) {
              return PrimaryButton(
                title: "Update",
                onPressed: isValid
                    ? () async {
                        UserModel userModel = appProvider.getUserInformation
                            .copyWith(
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
                        appProvider.updateUserInfoFirebase(
                            context, userModel, image);
                      }
                    : null,
              );
            },
          ),
          const SizedBox(
            height: 24.0,
          ),
          PrimaryButton(
            title: "Remove Profile Picture",
            onPressed: appProvider.getUserInformation.image != null &&
                    appProvider.getUserInformation.image!.isNotEmpty
                ? () async {
                    bool result = await showConfirmationDialog(
                      context: context,
                      title: 'Remove Profile Picture',
                      content: "Are you you sure you want to remove it? You can't undo this action.",
                    );

                    if (result) {
                      appProvider.removeProfilePictureFirebase(context);
                    }
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
