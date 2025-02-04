
import 'dart:developer';

import 'package:ecommerce_app/database.dart';
import 'package:ecommerce_app/models/cart_item.dart';

class CartService {
  // factory CartService() => _instance;
  CartService();
  // static final CartService _instance = CartService._internal();
   final db = Database();
  final Map<String, CartItem> _items = {};
  // Add an item to the cart
  Future<void> addItem(CartItem item) async{
final connection = await db.connection;
    await connection.query(
        'INSERT INTO cart (product_id,user_id, quantity) VALUES (?, ?, ?)',
        [int.parse(item.id), int.parse(item.userId),int.parse(item.quantity.toString())], // Values to insert
      );
   
  }

  // Get all cart items
  Future<List<CartItem>> getItems(String userId) async{
    final connection = await db.connection;

final results = await connection.query('SELECT cart.id,  cart.product_id, products.ar_name ,products.en_name ,products.image_url,products.price,cart.quantity FROM cart  JOIN products ON cart.product_id = products.id WHERE cart.user_id = ? ',[int.parse(userId)]);
    return results
        .map((row) => 
        
        CartItem.fromJson(row.fields)
        
        // {'id': row['id'], 'ar_name': row['ar_name'],
        // 'en_name' : row['en_name'],
        // }
        ,)
        .toList();
  }

  // Update an item in the cart
  Future<void> updateItem(int userId,int itemId, int quantity)async {
     final connection = await db.connection;
log('USER $userId');

    final result = await connection.query(
      'UPDATE cart SET quantity = ? WHERE product_id = ? AND user_id = ?', 
      [quantity, itemId ,userId],);
    
  }
 clearMyCart(int userId)async {
        final connection = await db.connection;

    final result = await connection.query(
      'Delete from cart where  user_id = ?', 
      [userId],);
  }
  // Remove an item from the cart
  void removeItem(String itemId) {
    _items.remove(itemId);
  }

  // Clear the cart
  void clearCart() {
    _items.clear();
  }
}
