import 'package:ecommerce_app/database.dart';
import 'package:ecommerce_app/models/banner.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/models/product_image.dart';
import 'package:ecommerce_app/models/variant.dart';
import 'package:ecommerce_app/models/variant_attribute.dart';


class ProductService {
   final db = Database();







 Future<void> addProduct(String arName,String enName,String desc,String image, double price,int category, int stock)async {
    final connection = await db.connection;
    final results = await connection.query('INSERT INTO products(ar_name ,	en_name ,	category ,	inventory_count 	,price ,	image_url , 	description  	 )  VALUES (? , ? ,? ,?,?,?,?)',
    
    [arName ,enName ,category ,stock ,price,image,desc],
    );
 
 
  }





  Future<List<Map<String, dynamic>>> getCategories() async {
    final connection = await db.connection;
    final results = await connection.query('SELECT id, ar_name ,en_name FROM categories');
    return results
        .map((row) => {'id': row['id'], 'ar_name': row['ar_name'],
        'en_name' : row['en_name'],
        },)
        .toList();
  }



  Future<List<Map<String, dynamic>>> searchCategories(String str) async {
    final connection = await db.connection;
    final results = await connection.query('SELECT id, ar_name ,en_name FROM categories   WHERE LOWER(ar_name) Like ? OR LOWER(en_name) Like ?' , ['%${str.toLowerCase()}%' , '%${str.toLowerCase()}%']);
    return results
        .map((row) => {'id': row['id'], 'ar_name': row['ar_name'],
        'en_name' : row['en_name'],
        },)
        .toList();
  }

  Future<List<Product>> getTopSales() async {
    final connection = await db.connection;
    var results = await connection.query('''
   SELECT 
   
  
   products.id,products.image_url, products.ar_name,products.inventory_count, products.price, SUM(order_items.quantity) AS total_sold FROM products  INNER JOIN order_items ON products.id = order_items.product_id GROUP BY products.id ORDER BY total_sold DESC LIMIT 4
    ''');
  if (results.isEmpty) {
    results = await connection.query('''
   SELECT  * FROM products  LIMIT 4
    ''');
  }

    return results
        .map((row) =>
        //  {
        //        'id': row['id'],
        //      'category': row['category'].toString(),
        //       'price': row['price'],
        //      'ar_name': row['ar_name'].toString()
        //       ,'en_name': row['en_name'].toString()
        //       ,
        //        'image_url': row['image_url'].toString(),
        //       'desc': row['description'].toString(),
        //     },
            
            Product.fromJson(row.fields),
            )
        .toList();
  }

 Future<List<Product>> getProducts() async {
    final connection = await db.connection;
    final results = await connection.query('''
   SELECT * FROM products
    ''');
    var products =<Product>[];

    products = results
        .map((row) =>
        //  {
        //       'id': row['id'],
        //      'category': row['category'].toString(),
        //       'price': row['price'],
        //      'ar_name': row['ar_name'].toString()
        //       ,'en_name': row['en_name'].toString()
        //       ,
        //        'image_url': row['image_url'].toString(),
        //       'desc': row['description'].toString(),  
        //     }
            
            Product.fromJson(row.fields)
            ,)
        .toList();
for (final p in products) {
  // Fetch variants
    final variantResults = await connection.query(
      'SELECT id, product_id, sku, price, stock FROM variants WHERE product_id = ?',
      [int.parse(p.id)],
    );

    final variants = <Variant>[];
    for (final variantRow in variantResults) {
      final variantId = int.parse(variantRow['id'].toString()) ;

      // Fetch attributes for the variant
      final attributeResults = await connection.query(
        '''
        SELECT va.id, a.name AS attribute_name, av.value
        FROM variant_attributes va
        INNER JOIN attribute_values av ON va.attribute_value_id = av.id
        INNER JOIN attributes a ON av.attribute_id = a.id
        WHERE va.variant_id = ?
        ''',
        [variantId],
      );

    final attributes = attributeResults.map((attrRow) {
        return VariantAttribute(
          id: int.parse(attrRow['id'].toString()),
          attributeName: attrRow['attribute_name'].toString(),
          value: attrRow['value'].toString(),
        );
      }).toList();

      variants.add(
        Variant(
          id: variantId,
          productId: variantRow['product_id'] as int,
          sku: variantRow['sku'].toString(),
          price: num.parse(variantRow['price'].toString()).toDouble(),
          stock: int.parse(variantRow['stock'].toString()),
          attributes: attributes,
        ),
      );
    }


p.variants!.addAll(variants);
 // Fetch product images
    final imageResults = await connection.query(
      'SELECT id, image_url, is_primary FROM product_images WHERE product_id = ?',
      [int.parse(p.id)],
    );

    final images = imageResults.map((row) {
      return ProductImage(
        id: row['id'] as int,
        imageUrl: row['image_url'] as String,
        isPrimary: row['is_primary'] == 1,
      );
    }).toList();
p.images!.addAll(images);
}
        return products;
  }
 
 Future<List<Product>> getRelatedProducts(int productId,int categoryId ,  ) async {
    final connection = await db.connection;
    final results = await connection.query('''
SELECT * from products
   WHERE category = ? AND id !=  ?
      LIMIT 4
    ''' ,    [categoryId, productId],);
    var products =<Product>[];
// return [];
    products = results
        .map((row) =>
        //  {
        //       'id': row['id'],
        //      'category': row['category'].toString(),
        //       'price': row['price'],
        //      'ar_name': row['ar_name'].toString()
        //       ,'en_name': row['en_name'].toString()
        //       ,
        //        'image_url': row['image_url'].toString(),
        //       'desc': row['description'].toString(),  
        //     }
            
            Product.fromJson(row.fields)
            ,)
        .toList();

        return products;
  }
 
 
 Future<List<Product>> searchProducts(String str) async {
    final connection = await db.connection;
    final results = await connection.query('''
   SELECT *
FROM products
WHERE  LOWER(ar_name) LIKE ? OR  LOWER(en_name) LIKE ? OR  LOWER(description) LIKE ?
    ''', ['%${str.toLowerCase()}%', '%${str.toLowerCase()}%' ,'%${str.toLowerCase()}%'],);
    var products =<Product>[];

    products = results
        .map((row) =>
        //  {
        //       'id': row['id'],
        //      'category': row['category'].toString(),
        //       'price': row['price'],
        //      'ar_name': row['ar_name'].toString()
        //       ,'en_name': row['en_name'].toString()
        //       ,
        //        'image_url': row['image_url'].toString(),
        //       'desc': row['description'].toString(),  
        //     }
            
            Product.fromJson(row.fields)
            ,)
        .toList();
for (final p in products) {
  // Fetch variants
    final variantResults = await connection.query(
      'SELECT id, product_id, sku, price, stock FROM variants WHERE product_id = ?',
      [int.parse(p.id)],
    );

    final variants = <Variant>[];
    for (final variantRow in variantResults) {
      final variantId = int.parse(variantRow['id'].toString()) ;

      // Fetch attributes for the variant
      final attributeResults = await connection.query(
        '''
        SELECT va.id, a.name AS attribute_name, av.value
        FROM variant_attributes va
        INNER JOIN attribute_values av ON va.attribute_value_id = av.id
        INNER JOIN attributes a ON av.attribute_id = a.id
        WHERE va.variant_id = ?
        ''',
        [variantId],
      );

    final attributes = attributeResults.map((attrRow) {
        return VariantAttribute(
          id: int.parse(attrRow['id'].toString()),
          attributeName: attrRow['attribute_name'].toString(),
          value: attrRow['value'].toString(),
        );
      }).toList();

      variants.add(
        Variant(
          id: variantId,
          productId: variantRow['product_id'] as int,
          sku: variantRow['sku'].toString(),
          price: num.parse(variantRow['price'].toString()).toDouble(),
          stock: int.parse(variantRow['stock'].toString()),
          attributes: attributes,
        ),
      );
    }


p.variants!.addAll(variants);
 // Fetch product images
    final imageResults = await connection.query(
      'SELECT id, image_url, is_primary FROM product_images WHERE product_id = ?',
      [int.parse(p.id)],
    );

    final images = imageResults.map((row) {
      return ProductImage(
        id: row['id'] as int,
        imageUrl: row['image_url'] as String,
        isPrimary: row['is_primary'] == 1,
      );
    }).toList();
p.images!.addAll(images);
}
        return products;
  }
 
 
 
Future<Product?> getProduct(String? userId, String id) async {

  Product? product;
    final connection = await db.connection;
    final results = await connection.query('''
   SELECT * FROM products WHERE id = ?
    ''' , [int.parse(id)],);

    if (results.isEmpty) {
      return null;
    }




    final row= results.first;

try {
      product  = Product(id: row['id'].toString(), 
    arName: row['ar_name'].toString(), enName: row['en_name'].toString(),
     des: row['description'].toString(), 
     imageUrl: row['image_url'].toString(),
    inventory: int.parse(row['inventory_count'].toString())
    , price: 
    
     double.parse(row['price'].toString())
    , 
    
    );
} catch (e) {
  
}
   
  // Fetch variants
    final variantResults = await connection.query(
      'SELECT id, product_id, sku, price, stock FROM variants WHERE product_id = ?',
      [int.parse(id)],
    );

    final variants = <Variant>[];
    for (final variantRow in variantResults) {
      final variantId = variantRow['id'] as int;

      // Fetch attributes for the variant
      final attributeResults = await connection.query(
        '''
        SELECT va.id, a.name AS attribute_name, av.value
        FROM variant_attributes va
        INNER JOIN attribute_values av ON va.attribute_value_id = av.id
        INNER JOIN attributes a ON av.attribute_id = a.id
        WHERE va.variant_id = ?
        ''',
        [variantId],
      );

    final attributes = attributeResults.map((attrRow) {
        return VariantAttribute(
          id: attrRow['id'] as int,
          attributeName: attrRow['attribute_name'] as String,
          value: attrRow['value'] as String,
        );
      }).toList();

      variants.add(
        Variant(
          id: variantId,
          productId: variantRow['product_id'] as int,
          sku: variantRow['sku'] as String,
          price: (variantRow['price'] as num).toDouble(),
          stock: variantRow['stock'] as int,
          attributes: attributes,
        ),
      );
    }

product!.setVariants(variants);

 // Fetch product images
     final images = <ProductImage>[];

    final imageResults = await connection.query(
      'SELECT id, image_url, is_primary FROM product_images WHERE product_id = ?',
      [int.parse(id)],
    );

for (final row in imageResults) {
  images.add(

    ProductImage(
        id: row['id'] as int ,
        imageUrl: row['image_url'].toString(),
        isPrimary: row['is_primary'] == 1,
      ),
  );
}
 
product.setImages(images);


//get cart data
final map =<String,dynamic>{};
if (userId!=null) {
  final cartResult = await connection.query('SELECT cart.id,  cart.product_id, products.ar_name ,products.en_name ,products.image_url,products.price,cart.quantity FROM cart  JOIN products ON cart.product_id = products.id WHERE cart.product_id = ? AND cart.user_id = ? ',[
  
  int.parse(id),
  int.parse(userId),]);
 
 if (cartResult.isNotEmpty) {
    map.addAll({
  'quantity':cartResult.first.fields['quantity'],
  'product_id':cartResult.first.fields['product_id'],
    });
 }

}
product.setCartItems(map);


//get related products
final relatedProducts = await getRelatedProducts(int.parse(id),
 
int.parse(row['category'].toString()),);

product.setRelatedProduct(relatedProducts);
    return product;
  }


 
 Future<List<Map<String, dynamic>>> getCategoryProducts(String id) async {
    final connection = await db.connection;
    final results = await connection.query('''
   SELECT * FROM products WHERE category = ?
    ''' ,[id],);
    if (results.isEmpty) {
      return [];
    }
    return results
        .map((row) => {
              'id': row['id'].toString(),
             'category': row['category'].toString(),
              'price': row['price'],
             'ar_name': row['ar_name'].toString()
              ,'en_name': row['en_name'].toString()
              ,
               'image_url': row['image_url'].toString(),
              'desc': row['description'].toString(),  
              'is_favourite': false,
              'inventory':row['inventory_count'],
            },)
        .toList();
  }











 // Add a product to the user's favorites
  Future<void> addFavorite(String userId, String productId) async{
        final connection = await db.connection;

    // _userFavorites.putIfAbsent(userId, () => []).add(productId);
    await connection.query('''
       INSERT INTO favourites (user_id ,product_id) VALUES (?,?)
    ''',[int.parse(userId),int.parse(productId)],);
  }

  // Remove a product from the user's favorites
  Future<void> removeFavorite(String userId, String productId)async {
            final connection = await db.connection;

    connection.query('''
       DELETE from favourites  WHERE user_id = ? AND product_id = ?
    ''',[userId,productId],);
  }

  // Get all favorite products for a user
 Future<List<Map<String, dynamic>>> getFavorites(String userId )async {
                final connection = await db.connection;

    final result= await connection.query('''
       SELECT products.id ,products.ar_name, products.en_name 
       , products.image_url ,products.price 
        from products JOIN favourites ON products.id= favourites.product_id WHERE user_id = ?
    ''',[int.parse(userId)],);

    if (result.isEmpty) {
      return [];
    }else {
  return result.map((row)=>{
    'id':row['id'],
    'price':row['price'],
    'en_name':row['en_name'].toString(),
        'ar_name':row['ar_name'].toString(),
                'image_url':row['image_url'].toString(),


  },).toList();
    }
  }

  // Check if a product is in the user's favorites
  Future<bool> isFavorite(String userId, String productId)async {
    final connection = await db.connection;

    // _userFavorites.putIfAbsent(userId, () => []).add(productId);
   final result= await connection.query('''
       SELECT * from favourites  WHERE user_id = ? AND product_id = ?
    ''',[int.parse(userId),int.parse(productId)],);

    return result.isNotEmpty;
  }




 Future<List<BannerOffer>> getBanners() async {
    final connection = await db.connection;
    final results = await connection.query('''
   SELECT * FROM banners
    ''');
    var products =<BannerOffer>[];

    products = results
        .map((row) =>
        //  {
        //       'id': row['id'],
        //      'category': row['category'].toString(),
        //       'price': row['price'],
        //      'ar_name': row['ar_name'].toString()
        //       ,'en_name': row['en_name'].toString()
        //       ,
        //        'image_url': row['image_url'].toString(),
        //       'desc': row['description'].toString(),  
        //     }
            
            BannerOffer.fromJson(row.fields)
            ,)
        .toList();

        
        return products;
  }
 
}
