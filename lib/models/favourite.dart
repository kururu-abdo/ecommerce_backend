class Favorite {

  Favorite({
    required this.userId,
    required this.productId,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      userId: json['userId'].toString(),
      productId: json['productId'].toString(),
    );
  }
  final String userId;
  final String productId;

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'productId': productId,
      };
}
