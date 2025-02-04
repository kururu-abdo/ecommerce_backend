class CartItem {

  CartItem({
    required this.id,
        required this.userId,

    required this.name,
        required this.arName,
    required this.enName,
    required this.urlImage,
    required this.product_id,

    required this.price,
    this.quantity = 1,
  });

  // Create CartItem from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'].toString(),
      product_id: int.parse(json['product_id'].toString()),
      userId: json['user_id'].toString(),
      name: json['name'].toString(),
      price:double.parse( json['price'].toString()),
      quantity: json['quantity']!=null?
      int.parse(json['quantity'].toString())
       : 1,
       arName: json['ar_name'].toString(),
       enName: json['en_name'].toString(),
      urlImage: json['image_url'].toString(),

    );
  }
  final String id;
    final String userId;
    final int product_id;

  final String name;
   final String arName;
    final String enName;
     final String urlImage;
  final double price;
  int quantity;

  // Convert CartItem to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id':product_id,
        'ar_name': arName,
        'en_name':enName,
        'image_url':urlImage,
        'price': price,
        'quantity': quantity,
   
      };
}
