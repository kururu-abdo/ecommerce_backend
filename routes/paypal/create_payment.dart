import 'package:dart_frog/dart_frog.dart';
import 'package:ecommerce_app/paypal_service.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    // Get the access token
    final accessToken = await getAccessToken();

    // Define the payment amount
    const amount = 10.00;

    // Create the payment
    final paymentResponse = await createPayment(accessToken, amount);

    // Extract the approval URL to redirect the user to
    final approvalUrl = paymentResponse['links']
        .firstWhere((link) => link['rel'] == 'approval_url')['href'];

    return Response.json(body: {
      'approvalUrl': approvalUrl,
      'paymentId': paymentResponse['id'],
    },);
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {'error': e.toString()},
    );
  }
}
