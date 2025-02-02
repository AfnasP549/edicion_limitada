import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edicion_limitada/model/product_model.dart';

class ProductService {
  final _firesotre = FirebaseFirestore.instance;

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final QuerySnapshot fetchProduct =
          await _firesotre.collection('product').get();

      return fetchProduct.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;

        if (data['imageUrls'] != null) {
          if (data['imageUrls'] is String) {
            data['imagUrls'] = [data['imageUrls']];
          } else if (data['imageUrls'] is List) {
            data['imageUrls'] = List<String>.from(data['imageUrls']);
          }
        } else {
          data['imageUrls'] = <String>[];
        }

        return ProductModel.fromMap(data);
      }).toList();
    } catch (e) {
      throw 'Failed to Fetch Product: $e';
    }
  }

  Future<List<String>> fetchBrands() async {
    try {
      final QuerySnapshot fetchBrand =
          await _firesotre.collection('brands').get();

      final brands = fetchBrand.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['name'] as String)
          .toSet()
          .toList();
          return brands;
    } catch (e) {
      throw 'Failed to Fetch Brands : $e';
    }
  }


}

