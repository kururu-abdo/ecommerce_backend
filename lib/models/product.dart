import 'package:ecommerce_app/models/product_image.dart';
import 'package:ecommerce_app/models/variant.dart';

class Product {

  Product({
    required this.id,
        required this.arName,
        required this.enName,
        required this.des,
         required this.inventory, required this.price, this.imageUrl,

         this.variants,this.images,

         this.cart,
  });

  // Create CartItem from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      arName: json['ar_name'].toString(),
      enName: json['en_name'].toString(),
      price:double.parse( json['price'].toString()),
      inventory: json['inventory_count']!=null?
      int.parse(json['inventory_count'].toString())
       : 0,
       des: json['description'].toString(),
       imageUrl:  json['image_url'].toString(),
       images: [],
       variants: [],
     cart: {},
       
    );
  }
  setCartItems(Map<String,dynamic>? cart){
    this.cart =cart;
  }
  setVariants(   List<Variant> variants){
    this.variants =variants;
  }
  setRelatedProduct(   List<Product> products){
    this.products =products;
  }
  setImages(List<ProductImage> images){
    this.images =images;
  }
  final String id;
    final String arName;
    final String enName;
    final String? imageUrl;
    final double price;
       List<Variant>? variants;
        List<Product>? products;
   List<ProductImage>? images;
Map<String,dynamic>? cart;
     bool? isFavorite=false;

  final String des;
  final int inventory;

  // Convert CartItem to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'ar_name': arName,
        'en_name':enName,
        'price':price ,
        'desc':des , 
        'image_url':imageUrl,
        'inventory':inventory,
        'is_favourite':isFavorite,
        'cart':cart??{}
,
        
         'variants':
         variants==null?[]:
         
          variants!.map((variant) => variant.toJson()).toList(),
         'images': 
         images==null?[]:
         images!.map((image)=>image.toJson()).toList(),
  "related":  products==null?[]
  :  products!.map((p)=> p.toJson()).toList()
        
  //       'price': price,

  //       'quantity': quantity,
      };
}
