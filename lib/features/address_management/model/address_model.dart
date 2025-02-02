  // ignore_for_file: public_member_api_docs, sort_constructors_first
  import 'dart:convert';

  class AddressModel {
    final String? id;
    final String name;
    final String phoneNumber;
    final String street;
    final String city;
    final String state;
    final String pincode;
    final bool isDefault;
    AddressModel({
      this.id,
      required this.name,
      required this.phoneNumber,
      required this.street,
      required this.city,
      required this.state,
      required this.pincode,
      required this.isDefault,
    });

    String get fullAddress => '$street, $city, $state ';

    AddressModel copyWith({
      String? id,
      String? name,
      String? phoneNumber,
      String? street,
      String? city,
      String? state,
      String? pincode,
      bool? isDefault,
    }) {
      return AddressModel(
        id: id ?? this.id,
        name: name ?? this.name,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        street: street ?? this.street,
        city: city ?? this.city,
        state: state ?? this.state,
        pincode: pincode ?? this.pincode,
        isDefault: isDefault ?? this.isDefault,
      );
    }

    Map<String, dynamic> toMap() {
      return <String, dynamic>{
       // 'id': id,
        'name': name,
        'phoneNumber': phoneNumber,
        'street': street,
        'city': city,
        'state': state,
        'pincode': pincode,
        'isDefault': isDefault,
      };
    }

    factory AddressModel.fromMap(String id, Map<String, dynamic> map) {
      return AddressModel(
        id: id,
        name: map['name'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        street: map['street'] ?? '',
        city: map['city'] ?? '',
        state: map['state'] ?? '',
        pincode: map['pincode'] ?? '',
        isDefault: map['isDefault'] ?? false,
      );
    }

    String toJson() => json.encode(toMap());

    //factory AddressModel.fromJson(String source) => AddressModel.fromMap(json.decode(source) as Map<String, dynamic>);

    @override
    String toString() {
      return 'AddressModel(id: $id, name: $name, phoneNumber: $phoneNumber, street: $street, city: $city, state: $state, pincode: $pincode, isDefault: $isDefault)';
    }

    @override
    bool operator ==(covariant AddressModel other) {
      if (identical(this, other)) return true;
    
      return 
        other.id == id &&
        other.name == name &&
        other.phoneNumber == phoneNumber &&
        other.street == street &&
        other.city == city &&
        other.state == state &&
        other.pincode == pincode &&
        other.isDefault == isDefault;
    }

    @override
    int get hashCode {
      return id.hashCode ^
        name.hashCode ^
        phoneNumber.hashCode ^
        street.hashCode ^
        city.hashCode ^
        state.hashCode ^
        pincode.hashCode ^
        isDefault.hashCode;
    }
  }
