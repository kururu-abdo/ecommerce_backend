// lib/user_repository.dart
import 'dart:async';
import 'dart:developer';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:ecommerce_app/database.dart';
import 'package:ecommerce_app/models/user.dart';

class UserService {

  UserService(
    // this._connection
    
    );
  // final MySqlConnection _connection;
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
  
  
  
  Future<User?> fetchFromToken(String token) async {
    final connection =await db.connection;
    // Logic to verify the token and retrieve the user from the database
    final result = await connection.query(
      'SELECT id, name, email FROM users WHERE token = ?', [token],);

    if (result.isNotEmpty) {
      final row = result.first;
      return User(
        id: row[0].toString(),
        userName: row[1] as String,
        email: row[2] as String,
      );
    } else {
      return null; // Return null if no user is found
    }
  }
  Future<List<Map<String, dynamic>>?> getMyAddresses(int id) async {
    final connection =await db.connection;
    // Logic to verify the token and retrieve the user from the database
    final result = await connection.query(
      'SELECT * FROM address WHERE user_id = ?', [id],);


return result.map((row)=>{

  'id':  row['id'],
  'user_id':  row['user_id'],
  
  'lat':  row['lat'],
  'lon':  row['lon'],
  'zip_code':  row['zip_code'].toString(),
'country':  row['country'].toString(),
  'city':  row['city'].toString(),
  'full_name':row['full_name'].toString(),

},).toList();
    
  }

   Future<void> addMyAdress(

    int userId,
    String fullName
    ,String 	country ,String	city ,double	lat ,double	lon ,
    String	street , String 	zipCode,
   ) async {
    final connection =await db.connection;
    // Logic to verify the token and retrieve the user from the database
    final result = await connection.query(
      'INSERT IGNORE INTO address (user_id , full_name,	country ,	city ,	lat ,	lon ,	street, 	zip_code) VALUES (? ,?,?,?,?,?,?,?)', [userId,fullName,country,city,lat,lon,street,zipCode],);


  }


   Future<void> updateAddress(
int addresId,
    int userId,String 	country ,String	city ,double	lat ,double	lon ,
    String	street , String 	zipCode,
   ) async {
    final connection =await db.connection;
    // Logic to verify the token and retrieve the user from the database
    final result = await connection.query(
      'UPDATE  address SET user_id = ? ,	country = ?,	city = ?,	lat = ?,	lon ,	street = ?, 	zip_code = ? WHERE id = ?', [userId,country,city,lat,lon,street,zipCode ,addresId],);


  }


   Future<void> deleteAddress(
int addresId,
    
   ) async {
    final connection =await db.connection;
    // Logic to verify the token and retrieve the user from the database
    final result = await connection.query(
      '	Delete from address WHERE id = ?',[addresId],);


  }


Future<void> deleteAccount(int userId) async {
      final connection =await db.connection;

    // Logic to verify the token and retrieve the user from the database
   await connection.query(
      'UPDATE users set active = 0 WHERE id = ?', [userId],);
    // if (result.isNotEmpty) {
    //   final row = result.first;
    //    User(
    //     id: row[0].toString(),
    //     userName: row[1] as String,
    //     email: row[2] as String,
    //   );
    // } else {
      // return null; // Return null if no user is found
    // }
  }
 
 

Future<void> updateFiebaseToken(String userId,String token) async {
      final connection =await db.connection;

    // Logic to verify the token and retrieve the user from the database
   await connection.query(
      'UPDATE users set firebase_token = ? WHERE id = ?', [token, int.parse(userId)],);
    // if (result.isNotEmpty) {
    //   final row = result.first;
    //    User(
    //     id: row[0].toString(),
    //     userName: row[1] as String,
    //     email: row[2] as String,
    //   );
    // } else {
      // return null; // Return null if no user is found
    // }
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

Future<Map<String, dynamic>?> decodeAndVerifyToken(String token) async {
  try {
    final jwt = JWT.verify(token, SecretKey('123')); // Replace with your secret key
    return jwt.payload as Map<String, dynamic>; // Return the payload as a map
  } catch (e) {
    print('Invalid token: $e');
    return null;
  }
}


}
