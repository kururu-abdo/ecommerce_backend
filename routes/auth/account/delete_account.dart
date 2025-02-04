import 'package:dart_frog/dart_frog.dart';
import 'package:ecommerce_app/models/user.dart';

import '../../../services/user_service.dart';

Future<Response> onRequest(RequestContext context) async {
  final userService = context.read<UserService>();
    final user = context.read<User>();
await userService.deleteAccount(int.parse(user.id!));
 // Respond with the updated profile data
  return Response.json(
    body: {
      'message': 'Account deleted successfully',
      // 'token': userProfile,
    },
  );

}