import 'dart:developer';

import 'package:bcrypt/bcrypt.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:ecommerce_app/database.dart';

List<Map<String, dynamic>> users = <Map<String, dynamic>>[];

Future<Response> onRequest(RequestContext context) async {
  final body = await context.request.json();
   final db = Database();
    final connection = await db.connection;
  final email = body['email'];
  final password = body['password'];
    final name = body['name'];
 
  
  if (email == null || password == null) {
    return Response.json(
      statusCode: 400,
      body: {'message': 'Email and password are required'},
    );
  }
  log('NO ERRROR HERE');
 final results = await connection.query(
      'SELECT password FROM users WHERE email = ? ',
      [email,
      ]
    );
  // Check if user exists
  // final existingUser = users.firstWhere(
  //   (user) => user['email'] == email,
  //   orElse: () => {},
  // );
  if (results.isNotEmpty) {
    return Response.json(
      statusCode: 400,
      body: {'message': 'User already exists'},
    );
  }

  // Hash password
  final hashedPassword = BCrypt.hashpw(password.toString(), BCrypt.gensalt());

  // Create new user
  // final user = {
  //   // 'id': const Uuid().v4(),
  //   'email': email,
  //   'name':name,
  //   'password': hashedPassword,
  // };

  // users.add(user);
await connection.query(
        'INSERT INTO users (name, email, password) VALUES (?, ?, ?)',
        [name, email, hashedPassword], // Values to insert
      );
  return Response.json(
    statusCode: 201,
    body: {'message': 'User registered successfully'},
  );
}
