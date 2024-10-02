import 'dart:convert';

class AppUser {
  final String? id;
  final String fullName;
  final String email;
  final String password;

  AppUser({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
  });

  AppUser copyWith({
    String? id,
    String? fullName,
    String? email,
    String? password
  }) {
    return AppUser(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        password: password ?? this.password
    );
  }

  Map<String, dynamic> toMap() =>
     <String, dynamic> {
      'fullName' : fullName,
      'email' : email,
      'password' : password,
    };


  factory AppUser.fromMap(Map<String, dynamic> map) =>
    AppUser(
      id: map['id'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );


  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.encode(source) as Map<String, dynamic>);

  @override
  String toString() =>
     'AppUser(id: $id, fullName: $fullName, email: $email, password: $password)';


  @override
  bool operator == (covariant AppUser other) {
    if(identical(this, other)) return true;

    return other.id == id &&
        other.fullName == fullName &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => id.hashCode ^ fullName.hashCode ^ email.hashCode ^ password.hashCode;

}