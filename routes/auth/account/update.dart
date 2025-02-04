import 'package:dart_frog/dart_frog.dart';

/// Mock data storage to simulate a user profile.
final userProfile = {
  'name': 'John Doe',
  'email': 'johndoe@example.com',
};

Future<Response> onRequest(RequestContext context) async {
  // Only allow PATCH requests for updating the profile
  if (context.request.method != HttpMethod.patch) {
    return Response(statusCode: 405, body: 'Method Not Allowed');
  }

  // Parse JSON from the request body
  final json = await context.request.json() as Map<String, dynamic>?;

  if (json == null || json.isEmpty) {
    return Response(statusCode: 400, body: 'Invalid request data');
  }

  // Extract fields from the JSON request
  final name = json['name'] as String?;
  final email = json['email'] as String?;

  // Validate the inputs
  if (name == null || name.isEmpty) {
    return Response(statusCode: 400, body: 'Name is required');
  }
  if (email == null || email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
    return Response(statusCode: 400, body: 'Valid email is required');
  }

  // Update the user profile (this would be where you update the database)
  userProfile['name'] = name;
  userProfile['email'] = email;

  // Respond with the updated profile data
  return Response.json(
    body: {
      'message': 'Profile updated successfully',
      'profile': userProfile,
    },
  );
}
