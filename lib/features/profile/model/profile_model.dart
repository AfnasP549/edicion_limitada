// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final int number;
  final int dob;
  final String? imageUrl;
  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.number,
    required this.dob,
    this.imageUrl,
  });
 

  UserModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    int? number,
    int? dob,
    String? imageUrl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      number: number ?? this.number,
      dob: dob ?? this.dob,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'number': number,
      'dob': dob,
      'imageUrl': imageUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      number: map['number'] as int,
      dob: map['dob'] as int,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, fullName: $fullName, email: $email, number: $number, dob: $dob, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.fullName == fullName &&
      other.email == email &&
      other.number == number &&
      other.dob == dob &&
      other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      fullName.hashCode ^
      email.hashCode ^
      number.hashCode ^
      dob.hashCode ^
      imageUrl.hashCode;
  }
}
