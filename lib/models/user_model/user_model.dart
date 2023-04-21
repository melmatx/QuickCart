import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.image,
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  String? image;
  String name;
  String email;
  String phone;
  String address;

  String id;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        image: json["image"],
        email: json["email"],
        name: json["name"],
        phone: json["phone"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
      };

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    image,
  }) =>
      UserModel(
        id: id,
        name: name ?? this.name,
        email: email ?? this.email,
        image: image ?? this.image,
        phone: phone ?? this.phone,
        address: address ?? this.address,
      );
}
