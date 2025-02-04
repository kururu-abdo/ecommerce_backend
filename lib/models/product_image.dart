class ProductImage {

  ProductImage({
    required this.id,
    required this.imageUrl,
    required this.isPrimary,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: int.parse(json['id'].toString()) ,
      imageUrl: json['image_url'].toString(),
      isPrimary:bool.parse( json['is_primary'].toString()),
    );
  }
  final int id;
  final String imageUrl;
  final bool isPrimary;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'is_primary': isPrimary,
    };
  }
}