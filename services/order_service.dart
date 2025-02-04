import 'package:ecommerce_app/database.dart';
import 'package:ecommerce_app/models/new_order.dart';
import 'package:ecommerce_app/models/order.dart';

class OrderService {

  OrderService();
   final db = Database();

 Future<List<Map<String, dynamic>>> getOrders(int userId, String status) async {
  final connection =await db.connection;
    final results = await connection.query('SELECT * FROM orders WHERE user_id = ? and status = ?' , 
    [userId , status],
    );
    return results
        .map((row) => {'id': row['id'].toString(), 'user_id': row['user_id'].toString(),
        'total_amount' : row['total_amount'].toString(),
        'status':row['status'].toString(),
        'created_at':row['created_at'].toString(),
                'updated_at':row['updated_at'].toString(),

        },)
        .toList();
  }



 Future<List<Map<String, dynamic>>> getAllOrders( String status) async {
  final connection =await db.connection;
    final results = await connection.query('SELECT * FROM orders WHERE  status = ?' , 
    [ status],
    );
    return results
        .map((row) => {'id': row['id'].toString(), 'user_id': row['user_id'].toString(),
        'total_amount' : row['total_amount'].toString(),
        'status':row['status'].toString(),
        'created_at':row['created_at'].toString(),
                'updated_at':row['updated_at'].toString(),

        },)
        .toList();
  }





Future<Order?> getOrderDetails(int orderId) async {
    final connection =await db.connection;

    final results = await connection.query('SELECT * FROM orders WHRE id = ?', 
    [orderId],
    );
    if (results.isEmpty) {
      return null;
    }
    final row = results.first;
   var orderData =<String,dynamic>{};
   orderData = row.fields;

   final items =  await getOrderItems(orderData['id'].toString());

   orderData['items'] = items;
  //  for (final item in items) {
  //    orderData.addAll({
  //     'pr'
  //    })
  //  }
   
  
  
    return Order.fromJson(row.fields);
  }
 Future<List<Map<String,dynamic>>> getOrderItems(String orderId) async {
    final connection =await db.connection;

    final results = await connection.query('''
 SELECT 
          oi.id AS order_item_id,
          oi.product_id,
          p.ar_name AS ar_name,
          p.en_name AS en_name,
          p.image_url as image_url,
          oi.quantity,
          oi.price AS item_price,
          (oi.quantity * oi.price) AS total_price
        FROM 
          order_items oi
        JOIN 
          products p ON oi.product_id = p.id
        WHERE 
          oi.order_id = ?      

'''
      , 
    [int.parse(orderId)],
    );
    return results
        .map((row) => row.fields)
        .toList();
  }
// Create an order from cart items

  Future<void> createOrder(NewOrder order) async{
      final connection =await db.connection;

    
    /*
    final total = items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    final order = Order(
      userId: userId,
      addressId: addressId,
      items: items,
      total: total,
    );
    */
    //insert order data in order table

   final orderResult = await connection.query('''
INSERT into orders (
   user_id, total_amount, tax, 
   delivery, discount, grand_total, status,
    address_id, note) 
    VALUES (?,?,? ,? ,?,?,?,?,?)
    ''',  
    [
     order.customerId , 
     order.totalAmount , 
     order.tax , 
     order.delivery ,
     order.discount, 
     order.grandTotal,
     order.status,
      order.addressId, 
      order.note,
    ]
    
    );
 // Commit the transaction
    await connection.query('COMMIT');
 final insertedId = orderResult.insertId;



    //insert items in order items

  for (final item in order.products) {
    final itemResult = await connection.query('''
INSERT into order_items
 (order_id, product_id, quantity, price)
VALUES
(?,?,?,?)
 ''',
 [insertedId ,item['product_id' ]
 , item['quantity'], 
 item['price'], 
 
 ]
 );
  }


  }
  

  // Update order status
  Future<void> updateOrderStatus(String orderId, String status) async{
      final connection =await db.connection;

    final results = await connection.query('SELECT * from orders WHERE id = ? ', 
    [orderId],
    );
  if (results.isNotEmpty) {
     final order = Order.fromJson(results.first.fields);
    
  }
  }
   
    
  
}