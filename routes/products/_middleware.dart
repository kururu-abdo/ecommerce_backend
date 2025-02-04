import 'package:dart_frog/dart_frog.dart';
import 'package:ecommerce_app/database.dart';
import 'package:mysql1/mysql1.dart';

import '../../services/product_service.dart';
import '../../services/user_service.dart';

final _productService = ProductService();

Handler middleware(Handler handler) {
  final db = Database();
 late MySqlConnection conn;
   db.connection.then((connection){
    conn=connection;
   });
  return handler
      .use(requestLogger())
      
      .use(provider<ProductService>((context) => ProductService()))
       .use(provider<UserService>((context) => UserService()))
      // .use(bearerAuthentication<User>(
      // authenticator: (context, token) async {
      //   final authenticator = context.read<UserService>();
      //   return   authenticator.verifyToken(token);
      // },
      
      //  applies: (RequestContext context) async =>
      //         context.request.method != HttpMethod.post,
      // ),
      // )
      
      ;
}