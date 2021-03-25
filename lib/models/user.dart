import 'dart:convert';

class User {
  String id;
  String name;
  String email;
  String birthdate;
  String password;

  User({this.id,this.name, this.email, this.birthdate, this.password});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'birthdate': birthdate,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return User(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      birthdate: map['birthdate'] ?? '',
      password: map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
