class AdsModel {
  final String id;

  final String imageUrl;

  AdsModel({
    required this.id,
    required this.imageUrl,
  });

  factory AdsModel.fromMap(Map<String, dynamic> map, String id) {
    return AdsModel(
      id: id,
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
    };
  }
}
