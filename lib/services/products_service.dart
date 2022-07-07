import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutterproductosapp-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  bool isLoading = true;
  bool isSaving = false;
  late Product productSelected;

  ProductsService() {
    getProducts();
  }

  Future<List<Product>> getProducts() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, '/products.json');
    final request = await http.get(url);
    final Map<String, dynamic> productsMap = json.decode(request.body);
    productsMap.forEach((key, value) {
      final temProduct = Product.fromMap(value);
      temProduct.id = key;
      products.add(temProduct);
    });

    isLoading = false;
    notifyListeners();
    return products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id != null) {
      await updateProduct(product);
      isSaving = false;
      return;
    }
    {
      //crear
    }
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, '/products/${product.id}.json');
    print('url $url');

    final request = await http.put(url, body: product.toJson());
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = Product.fromJson(json.decode(request.body));
    products[index].id = product.id;
    notifyListeners();
    return 'exito';
  }
}
