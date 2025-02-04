import 'package:dart_frog/dart_frog.dart';

import '../../services/product_service.dart';


Future<Response> onRequest(RequestContext context) async {

  final productService = context.read<ProductService>();
  // Fetch banners that are currently valid
  final now = DateTime.now();
  final mockBanners = await productService.getBanners();
  final activeBanners = mockBanners
      .where((banner) => banner.validFrom.isBefore(now) &&
       banner.validTo.isAfter(now))
      .toList();

  return Response.json(
    body: {
      'banners': activeBanners.map((banner) => banner.toJson()).toList(),
    },
  );
}
