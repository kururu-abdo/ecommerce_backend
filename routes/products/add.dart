  import 'package:dart_frog/dart_frog.dart';

import '../../services/product_service.dart';


  Future<Response> onRequest(RequestContext context) async {
     final productService = context.read<ProductService>();
final payload = await context.request.json() as Map<String, dynamic>;
  final arName = payload['ar_name'];
  final enName = payload['en_name'];
  final category = payload['category'];
  final stock = payload['stock'];
  final price = payload['price'];
  final image = payload['image'];
  final desc = payload['desc'];

await productService.addProduct(arName.toString(), enName.toString(), 
desc.toString(), image.toString(), 
double.parse(price.toString()), 
int.parse(category.toString()), int.parse(stock.toString()),);

return Response.json(body: {});
  }