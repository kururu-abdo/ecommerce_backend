import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app/paypal_config.dart';

// Get an access token
Future<String> getAccessToken() async {
  final response = await http.post(
    Uri.parse('$paypalBaseUrl/v1/oauth2/token'),
    headers: {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$paypalClientId:$paypalSecret'))}',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {'grant_type': 'client_credentials'},
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return json['access_token'].toString();
  } else {
    throw Exception('Failed to obtain PayPal access token');
  }
}

// Create a payment
Future createPayment(String accessToken, double amount) async {
  final response = await http.post(
    Uri.parse('$paypalBaseUrl/v1/payments/payment'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({
      'intent': 'sale',
      'redirect_urls': {
        'return_url': 'https://yourapp.com/return',
        'cancel_url': 'https://yourapp.com/cancel',
      },
      'payer': {'payment_method': 'paypal'},
      'transactions': [
        {
          'amount': {
            'total': amount.toStringAsFixed(2),
            'currency': 'USD',
          },
          'description': 'Payment description',
        }
      ],
    }),
  );

  if (response.statusCode == 201) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to create PayPal payment');
  }
}
