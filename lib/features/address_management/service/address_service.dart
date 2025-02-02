import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edicion_limitada/features/address_management/model/address_model.dart';

class AddressService {
  final FirebaseFirestore _firestore;
  final String userId;

  AddressService({required this.userId}):_firestore = FirebaseFirestore.instance;


  //!add
  Future<void> addAddress(AddressModel address)async{
    try{
       if (userId.isEmpty) {
        throw Exception('User ID cannot be empty');
      }

       final addressCollection = _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses');

           final addresses = await addressCollection.get();
      final isFirstAddress = addresses.docs.isEmpty;

       final addressData = address.copyWith(isDefault: isFirstAddress).toMap();

       await addressCollection.add(addressData);
    }catch(e){
      throw Exception('Failed to add address: $e');
    }
  }


  //!get
  Future<List<AddressModel>> getAddresses() async{
    try{
      final snapshot = await _firestore.collection('users').doc(userId).collection('addresses').get();
      return snapshot.docs.map((doc)=> AddressModel.fromMap(doc.id, doc.data())).toList();
    }catch(e){
      throw Exception('Failed to fetch addresses: $e');
    }
  }

  //!edit
  Future<void> updateAddress(String addressId, AddressModel address) async{
     try {
       if (userId.isEmpty || addressId.isEmpty) {
        throw Exception('User ID and Address ID cannot be empty');
      }

      final addressRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .doc(addressId);

      // Remove the id from the map since we don't want to update it
      final addressMap = address.toMap();
      addressMap.remove('id');  // Important: Remove ID from map

      await addressRef.update(addressMap);
    } catch (e) {
      throw Exception('Failed to update address: $e');
    }
  }

  //!delete
  Future<void> deleteAddress(String addressId)async{
    try {

       if (userId.isEmpty || addressId.isEmpty) {
        throw Exception('User ID and Address ID cannot be empty');
      }

    final addressRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .doc(addressId);

          final addressDoc = await addressRef.get();
          if(!addressDoc.exists){
            throw Exception('Address not found');
          }

          final addressData = addressDoc.data();
          if(addressData != null && addressData['isDefault'] == true){
            final addresses = await _firestore.collection('users').doc(userId).collection('addresses')
            .where(FieldPath.documentId, isEqualTo: addressId).limit(1).get();

            if(addresses.docs.isNotEmpty){
              await addresses.docs.first.reference.update({'isDefault' : true});
            }
          }
         await addressRef.delete();
    } catch (e) {
      throw Exception('Failed to delete address: $e');
  }
}
}