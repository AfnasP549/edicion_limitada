// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String uid;
  final String fullName;
  final String email;
  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
  });
 
  

  UserModel copyWith({
    String? uid,
    String? fullName,
    String? email,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'fullName': fullName,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserModel(uid: $uid, fullName: $fullName, email: $email)';

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.fullName == fullName &&
      other.email == email;
  }

  @override
  int get hashCode => uid.hashCode ^ fullName.hashCode ^ email.hashCode;
}
