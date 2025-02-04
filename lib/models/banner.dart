class BannerOffer {
  final String id;
  final String title;
  final int? productId;
  final String description;
  final String imageUrl;
  final String offerDetails; // e.g., "50% off on all electronics"
  final DateTime validFrom;
  final DateTime validTo;

  BannerOffer({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.offerDetails,
    required this.validFrom,
    required this.validTo,

    this.productId
  });

  // Convert BannerOffer to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id':productId,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'details': offerDetails,
      'valid_through': validFrom.toIso8601String(),
      'valid_to': validTo.toIso8601String(),
    };
  }

  // Create BannerOffer from JSON
  factory BannerOffer.fromJson(Map<String, dynamic> json) {
    return BannerOffer(
      id: json['id'].toString(),
      productId: int.tryParse(json['product_id'].toString()),
      title: json['title'] .toString(),
      description: json['description'] .toString(),
      imageUrl: json['image_url'] .toString(),
      offerDetails: json['details'] .toString(),
      validFrom: DateTime.parse(json['valid_through'] .toString()),
      validTo: DateTime.parse(json['valid_to'] .toString()),
    );
  }
}
