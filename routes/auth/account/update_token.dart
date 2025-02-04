import 'package:dart_frog/dart_frog.dart';

import '../../../services/user_service.dart';

/// Mock data storage to simulate a user profile.
final userProfile = {
  'name': 'John Doe',
  'email': 'johndoe@example.com',
};

Future<Response> onRequest(RequestContext context) async {
  final body = await context.request.json();
  final token = body['fcm_token'];
    final userId = body['user_id'];

  // Only allow PATCH requests for updating the profile
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405, body: 'Method Not Allowed');
  }
if (token==null) {
    return Response(statusCode: 422, body: 'Token is required');
}
final userService = context.read<UserService>();
await userService.updateFiebaseToken(userId.toString(), token.toString());
 

 

  // Respond with the updated profile data
  return Response.json(
    body: {
      'message': 'Token updated successfully',
      // 'token': userProfile,
    },
  );
}
