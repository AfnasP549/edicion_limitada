import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edicion_limitada/features/home_screen/model/ads_model.dart';

class AdsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AdsModel>> fetchAds() async {
    try {
      final fetch = await _firestore.collection('ads').get();
      return fetch.docs.map((doc) {
        return AdsModel.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch ads: $e');
    }
  }
}