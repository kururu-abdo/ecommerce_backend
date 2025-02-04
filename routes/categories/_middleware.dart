import 'package:dart_frog/dart_frog.dart';

import '../../services/product_service.dart';

// final productService = ProductService();

 Handler middleware(Handler handler) {
    return handler
    .use(requestLogger())
    // .use(bearerAuthentication<User>(
    //   authenticator: (context, token) async {
    //     final authenticator = context.read<UserService>();
    //     return authenticator.verifyToken(token);
    //   },
    // ),)
    .use(provider<ProductService>((context) => ProductService()));
  }
  