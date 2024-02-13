import 'dart:ffi';

class ModelUser {
  final int id;
  final String name;
  final String email;
  final String numberPhone;
  final bool active;
  final List roles;

  ModelUser({required this.id,required this.name, required this.email, required this.numberPhone, required this.active, required this.roles});

  factory ModelUser.fromJson(Map<String, dynamic> json) {
    return ModelUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      numberPhone: json['numberPhone'],
      active: json['active'],
      roles: json['roles'],
    );
  }
}