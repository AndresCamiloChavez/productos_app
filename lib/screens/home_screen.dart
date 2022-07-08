import 'package:flutter/material.dart';
import 'package:productos_app/models/product.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String homeRoute = 'home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);
    if (productService.isLoading) return const LoadingScreen();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Producto'),
        ),
        body: ListView.builder(
            itemCount: productService.products.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  child: ProductoCard(
                    product: productService.products[index],
                  ),
                  onTap: () {
                    productService.productSelected =
                        productService.products[index].copy();
                    Navigator.pushNamed(context, ProductScreen.productRoute);
                  });
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            productService.productSelected =
                Product(available: true, name: '', price: 0);
            Navigator.pushNamed(context, ProductScreen.productRoute);
          },
          child: const Icon(Icons.add),
        ));
  }
}
