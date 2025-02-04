import 'dart:developer';

import 'package:dart_frog/dart_frog.dart';

import '../../services/address_service.dart';
import '../../services/user_service.dart';

final addressService = AddressService();

Future<Response> onRequest(RequestContext context) async {
  final userId = context.request.headers['userId']; // Assume userId is sent in headers for simplicity
final authHeader = context.request.headers['Authorization'];
 final userService  = context.read<UserService>();

  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response.json(statusCode: 401, body: {'error': 'UnAuthenticated'});

  }
  final token = authHeader.substring(7); // Remove 'Bearer ' prefix
  // TODO: Fetch product and check stock availability
  final user =await userService.verifyToken(token);
  if (user == null) {
    return Response.json(statusCode: 401, body: {'error': 'UnAuthenticated'});
  }

  if (context.request.method == HttpMethod.get) {
    // Retrieve all addresses for the user
    final addresses =await userService.getMyAddresses(int.parse(user.id!));
log(addresses.toString());
    // return Response.json(body: {'addresses': addresses});
        return Response.json(
        
          body: addresses);

  } else if (context.request.method == HttpMethod.post) {
    // Add a new address for the user
    // final address = Address.fromJson({...payload, 'userId': userId});
    // final newAddress = addressService.addAddress(address);
    // return Response.json(statusCode: 201, body: newAddress.toJson());
        // return Response.json(statusCode: 201, body: {});
return _onPost(context, user.id!);
  }

  return Response(statusCode: 405);
}
Future<Response> _onPost(RequestContext context , String userId)async{
      final payload = await context.request.json() as Map<String, dynamic>;
final country = payload['country'].toString();
final city = payload['city'].toString();
final lat = double.parse(payload['lat'].toString());
final lon = double.parse(payload['lon'].toString());
final street = payload['street'].toString();
final zipCod = payload['zip_code'].toString();
final fullName = payload['name'].toString();

 final userService  = context.read<UserService>();

 	 	 	 	 	//GET USER FROM TOKEN
await userService.addMyAdress(int.parse(userId),fullName, country, city, lat, lon, street, zipCod);

return Response.json(body: {
  'message':'address added',
},);

}