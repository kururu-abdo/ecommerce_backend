// lib/routes/_middleware.dart
import 'package:dart_frog/dart_frog.dart';

import '../../middleware/auth_middleware.dart';
import '../../services/cart_service.dart';
import '../../services/order_service.dart';
import '../../services/user_service.dart';


// The middleware function
Handler middleware(Handler handler) {
 
  return authMiddleware(handler)
  .use(requestLogger())
  .use(provider<UserService>((handler)=> UserService()))
    .use(provider<OrderService>((handler)=> OrderService()))
.use(provider<CartService>((handler)=> CartService()));
  ;
  // .use(bearerAuthentication<User>(
  //   authenticator: (context, token) async {
  //     final userService = UserService(conn);
  //     final user = await userService.fetchFromToken(token.toString());
  //     return user; // This returns the authenticated user
  //   },
  // ));
}