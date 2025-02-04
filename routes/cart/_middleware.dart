import 'package:dart_frog/dart_frog.dart';
import 'package:ecommerce_app/database.dart';
import 'package:mysql1/mysql1.dart';

import '../../middleware/auth_middleware.dart';
import '../../services/cart_service.dart';
import '../../services/user_service.dart';

Handler middleware(Handler handler) {
    final db = Database();

  return
  //  handler
  
       authMiddleware(handler)
      .use(requestLogger())
      .use(provider<UserService>((handler)=> UserService()))
        .use(provider<CartService>((handler)=> CartService()));
      // .use(provider<ProductRepository>((_) => _productRepository));
}