// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BrandModel {
  final String name;
  final String imagUrl;
  BrandModel({
    required this.name,
    required this.imagUrl,
  });

  BrandModel copyWith({
    String? name,
    String? imagUrl,
  }) {
    return BrandModel(
      name: name ?? this.name,
      imagUrl: imagUrl ?? this.imagUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'imagUrl': imagUrl,
    };
  }

  factory BrandModel.fromMap(Map<String, dynamic> map) {
    return BrandModel(
      name: map['name'] as String,
      imagUrl: map['imagUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BrandModel.fromJson(String source) => BrandModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BrandModel(name: $name, imagUrl: $imagUrl)';

  @override
  bool operator ==(covariant BrandModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.imagUrl == imagUrl;
  }

  @override
  int get hashCode => name.hashCode ^ imagUrl.hashCode;
}
