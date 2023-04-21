import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel(
      {required this.image,
      required this.id,
      required this.name,
      required this.price,
      required this.description,
      required this.isFavourite,
      required this.dateAdded,
      this.qty});

  String image;
  String id;
  bool isFavourite;
  String name;
  double price;
  String description;

  int? qty;
  Timestamp? dateAdded;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        isFavourite: false,
        qty: json["qty"],
        dateAdded: json["dateAdded"],
        price: double.parse(json["price"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "description": description,
        "isFavourite": isFavourite,
        "price": price,
        "qty": qty,
        "dateAdded": dateAdded,
      };
  ProductModel copyWith({
    int? qty,
    Timestamp? dateAdded,
  }) =>
      ProductModel(
        id: id,
        name: name,
        description: description,
        image: image,
        isFavourite: isFavourite,
        qty: qty ?? this.qty,
        price: price,
        dateAdded: dateAdded ?? this.dateAdded,
      );
}
