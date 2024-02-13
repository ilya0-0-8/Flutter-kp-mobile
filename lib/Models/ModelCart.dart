import 'dart:ffi';

import 'package:kp/Models/ModelProduct.dart';

import 'ModelUser.dart';



class ModelCart {
  final int id;
  final int count;
  final int total;
  final ModelProduct product;
  final ModelUser user;

  ModelCart({required this.id, required this.count, required this.total, required this.product, required this.user});

  factory ModelCart.fromJson(Map<String, dynamic> json) {
    return ModelCart(
      id: json['id'],
      count: json['count'],
      total: json['total'],
      product: ModelProduct.fromJson(json['product']),
      user: ModelUser.fromJson(json['user']),
    );
  }
}