class ModelLogin {
  final List roles;
  final int id;

  ModelLogin({required this.roles, required this.id});

  factory ModelLogin.fromJson(Map<String, dynamic> json) {
    return ModelLogin (
      roles: json['roles'],
      id: json['id'],
    );
  }
}