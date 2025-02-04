import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import '../../services/address_service.dart';
import '../../services/user_service.dart';

final addressService = AddressService();

Future<Response> onRequest(RequestContext context) async {
 final userService = context.read<UserService>();
 final authHeader = context.request.headers['Authorization'];
 final body = await context.request.body();

  final data = jsonDecode(body) as Map<String, dynamic>;
  final street = data['street'].toString();
    final country = data['country'].toString();

  final city = data['city'].toString();
  final zipCode = data['zip_code'].toString();
  final id =int.parse(data['id'].toString());
  final lat = double.parse(data['lat'].toString());
  final lon = double.parse(data['lon'].toString());


  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response.json(statusCode: 401, body: {'error': 'UnAuthenticated'});

  }
  final token = authHeader.substring(7); // Remove 'Bearer ' prefix
  // TODO: Fetch product and check stock availability
  final user =await userService.verifyToken(token);
  if (user == null) {
    return Response.json(statusCode: 401, body: {'error': 'UnAuthenticated'});
  }
 if ([id,street, city, country, zipCode].any(( field) => field.toString().isEmpty)) {
    return Response.json(
      body: {'error': 'Missing or invalid fields'},
      statusCode: 400,
    );
  }
    final addresses =await userService.updateAddress(id, int.parse(user.id!), country, city, lat, lon, street, zipCode);






  // final updatedAddress = Address.fromJson(payload);
  // final result = addressService.updateAddress(userId, "3", updatedAddress);

  // if (result == null) {
  //   return Response.json(statusCode: 404, body: {'error': 'Address not found'});
  // }
  return Response.json(body:{
    'message':'Adress updated successfuly',
  },);

  // return Response.json(body: result.toJson());
}
