import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:ecommerce_app/paypal_config.dart';
import 'package:ecommerce_app/paypal_service.dart';
import 'package:http/http.dart' as http;

Future<Response> onRequest(RequestContext context) async {
  try {
    final queryParams = context.request.uri.queryParameters;
    final paymentId = queryParams['paymentId'];
    final payerId = queryParams['PayerID'];

    if (paymentId == null || payerId == null) {
      return Response.json(
        statusCode: 400,
        body: {'error': 'Missing paymentId or PayerID'},
      );
    }

    // Get the access token
    final accessToken = await getAccessToken();

    // Capture the payment
    final response = await http.post(
      Uri.parse('$paypalBaseUrl/v1/payments/payment/$paymentId/execute'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({'payer_id': payerId}),
    );

    if (response.statusCode == 200) {
      return Response.json(body: {'message': 'Payment successful!'});
    } else {
      return Response.json(
        statusCode: response.statusCode,
        body: {'error': 'Failed to capture payment'},
      );
    }
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {'error': e.toString()},
    );
  }
}
