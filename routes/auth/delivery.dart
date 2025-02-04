import 'package:bcrypt/bcrypt.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:ecommerce_app/database.dart';
// List<Map<String, dynamic>> users = <Map<String, dynamic>>[];

Future<Response> onRequest(RequestContext context) async {
  final body = await context.request.json();
  final email = body['phone'];
  final password = body['password'];
   final db = Database();
    final connection = await db.connection;


    // Sample query
    // final results = await connection.query('SELECT id, name FROM users where ');
 
  if (email == null || password == null) {
    return Response.json(
      statusCode: 400,
      body: {'message': 'Email and password are required'},
    );
  }
  final results = await connection.query(
      'SELECT id, email ,name , password FROM users WHERE email = ?  AND delivert = ? ',
      [email , 1],
    );

  // Find user
if (results.isEmpty) {
   return Response.json(
      statusCode: 403,
      body: {'message': 'Wrong credentials'},
    );
}


final user=results.first;
  // final user = results(
  //   (user) => user['email'] == email,
  //   orElse: () => {},
  // );
// log(results.first[0]['name'].toString());
  if (!BCrypt.checkpw(password.toString(), user['password'].toString())) {
    return Response.json(
      statusCode: 400,
      body: {'message': 'Invalid credentials'},
    );
  }

  // Create JWT token
  final payload = {'id': user['id'].toString(),'name':user['name'].toString() ,
  'email':user['email'].toString(),};
  final jwt = JWT(payload,);
  final token = jwt.sign(SecretKey('123'), 
  expiresIn: const Duration(days: 1),
  );

  return Response.json(
    body: {'token': token, 
    'id':user['id'].toString(),
    'name':user['name'].toString(),
    'email':user['email'].toString(),
    },
  );
}
