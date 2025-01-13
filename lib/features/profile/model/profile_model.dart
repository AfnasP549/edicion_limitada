// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final int number;
  final int dob;
  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.number,
    required this.dob,
  });
 

  UserModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    int? number,
    int? dob,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      number: number ?? this.number,
      dob: dob ?? this.dob,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'number': number,
      'dob': dob,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      number: map['number'] as int,
      dob: map['dob'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, fullName: $fullName, email: $email, number: $number, dob: $dob)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.fullName == fullName &&
      other.email == email &&
      other.number == number &&
      other.dob == dob;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      fullName.hashCode ^
      email.hashCode ^
      number.hashCode ^
      dob.hashCode;
  }
}
