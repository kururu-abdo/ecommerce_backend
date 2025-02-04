import 'package:dart_frog/dart_frog.dart';
import 'package:ecommerce_app/models/user.dart';

import '../../services/address_service.dart';
import '../../services/user_service.dart';

final addressService = AddressService();

Future<Response> onRequest(RequestContext context) async {
final user = context.read<User>()  ;
  final userService = context.read<UserService>();

  final payload = await context.request.json() as Map<String, dynamic>;
  final addressId = payload['id'];
  if (addressId == null) {
    return Response.json(statusCode: 400, body: {'error': 'Address ID is required'});
  }

  // final result = addressService.deleteAddress(userId, "addressId");
  // if (!result) {
  //   return Response.json(statusCode: 404, body: {'error': 'Address not found'});
  // }
await userService.deleteAddress(int.parse(addressId.toString()));
  return Response.json(body: {'message': 'Address deleted'});
}
