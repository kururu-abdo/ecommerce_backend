import 'package:dart_frog/dart_frog.dart';

import '../../services/payment_service.dart';

Future<Response> onRequest(RequestContext context) async {
 final paymentervice = context.read<PaymentService>();
  // Return the list of gateways as JSON
  final  gateways = await paymentervice.getPaymentGatways();
  return Response.json(
    body: gateways.map((gateway) => gateway.toJson()).toList(),
  );
}
