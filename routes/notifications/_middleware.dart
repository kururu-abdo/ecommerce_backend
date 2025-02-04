// lib/routes/_middleware.dart
import 'package:dart_frog/dart_frog.dart';
import 'package:ecommerce_app/database.dart';
import 'package:mysql1/mysql1.dart';

import '../../services/notification_service.dart';
import '../../services/user_service.dart';


// The middleware function
Handler middleware(Handler handler) {
  final db = Database();
 late MySqlConnection conn;
   db.connection.then((connection){
    conn=connection;
   });
  return handler
  .use(requestLogger())
  .use(provider<UserService>((handler)=> UserService()))
    .use(provider<NotificationService>((handler)=> NotificationService()))
  ;
  // .use(bearerAuthentication<User>(
  //   authenticator: (context, token) async {
  //     final userService = UserService(conn);
  //     final user = await userService.fetchFromToken(token.toString());
  //     return user; // This returns the authenticated user
  //   },
  // ));
}