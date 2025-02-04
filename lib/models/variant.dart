import 'package:ecommerce_app/models/variant_attribute.dart';

class Variant {
  final int id;
  final int productId;
  final String sku;
  final double price;
  final int stock;
  final List<VariantAttribute> attributes;

  Variant({
    required this.id,
    required this.productId,
    required this.sku,
    required this.price,
    required this.stock,
    required this.attributes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'sku': sku,
      'price': price,
      'stock': stock,
      'attributes': attributes.map((attr) => attr.toJson()).toList(),
    };
  }
}
