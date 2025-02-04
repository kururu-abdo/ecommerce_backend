class OrderItem {

  OrderItem({
  
        required this.orderId,

   
    required this.product_id,

    required this.price,
    this.quantity = 1,
  });

  // Create CartItem from JSON
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderId: int.parse(json['order_id'].toString()),
   
      product_id: int.parse(json['product_id'].toString()),
     
      price:double.parse( json['price'].toString()),
      quantity: json['quantity']!=null?
      int.parse(json['quantity'].toString())
       : 1,
      

    );
  }
    final int orderId;
    final int product_id;

  final int quantity;
   final double price;
   

  // Convert CartItem to JSON
  Map<String, dynamic> toJson() => {
     
        'product_id':product_id,
        'order_id': orderId,
        'quantity':quantity,
    
        'price': price,
     
   
      };
}
