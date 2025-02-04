import 'dart:developer';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:ecommerce_app/database.dart';
import 'package:ecommerce_app/models/user.dart';

/// Middleware to authenticate user and attach user data to the context.
Handler authMiddleware(Handler handler) {
  return (context) async {
    final authHeader = context.request.headers['Authorization'];

    // Check if the Authorization header is missing
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return Response.json(
        body: {'error': 'Unauthorized'},
        statusCode: 401,
      );
    }

    // Extract the token
    final token = authHeader.substring(7); // Remove "Bearer "
    final user =await verifyToken(token);

    if (user == null) {
      return Response.json(
        body: {'error': 'Invalid or expired token'},
        statusCode: 403,
      );
    }

    // Attach the user data to the context
    return handler(context.provide<User?>(() => user));
  };
}
Future<User?> verifyToken(String token) async{
    try {
      final payload = JWT.verify(
        token,
        SecretKey('123'),
      );

      final payloadData = payload.payload as Map<String, dynamic>;
      log(payloadData.toString());
      final uid = payloadData['id'].toString();
      return _getUser(uid);
    } catch (e) { print(e);
      return null;
    }
  }

final db = Database();
  Future<User?> _getUser(String id)async{
  try {
     final db = Database();
    final connection = await db.connection;
  final results = await connection.query(
      'SELECT id, email ,name , password FROM users WHERE id = ?  ',
      [id],
    );

  // Find user
if (results.isEmpty) {
   return null;
}


final user=results.first;
    return User(
      id: user['id'].toString(),
      userName: user['name'].toString(),
      email: user['email'].toString(),
    );
  } catch (e) {
    return null;
  }
  }
  
/// Mock function to decode the token and fetch user data
Future<Map<String, dynamic>?> decodeAndVerifyToken(String token) async {
  try {
    final jwt = JWT.verify(token, SecretKey('123')); // Replace with your secret key
    return jwt.payload as Map<String, dynamic>; // Return the payload as a map
  } catch (e) {
    print('Invalid token: $e');
    return null;
  }
}

