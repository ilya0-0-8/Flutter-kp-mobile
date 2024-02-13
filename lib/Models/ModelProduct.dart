import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'ModelUser.dart';

class ModelProduct {
  final int id;
  final String name;
  final String description;
  final int price;
  final Uint8List image;
  final List list_users;
  final ModelUser user;

  ModelProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.list_users,
    required this.user,
    required this.image,
  });

  factory ModelProduct.fromJson(Map<String, dynamic> json) {
    String base64Image = json['image'];
    Uint8List uint8List = base64Decode(base64Image);

    return ModelProduct(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      list_users: json['list_users'],
      user: ModelUser.fromJson(json['user']),
      image: uint8List,
    );
  }
}