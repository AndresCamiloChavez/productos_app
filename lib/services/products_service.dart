import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutterproductosapp-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  bool isLoading = true;
  bool isSaving = false;
  late Product productSelected;
  File? newPictureFile;

  ProductsService() {
    getProducts();
  }
  void updateSelectedProductImage(String path) {
    productSelected.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
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
    } else {
      await createdProduct(product);
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

  Future<String> createdProduct(Product product) async {
    print('valor producto ${product.toJson()}');
    final url = Uri.https(_baseUrl, '/products.json');
    final request = await http.post(url, body: product.toJson());
    final decodeData = json.decode(request.body);
    product.id = decodeData['name'];
    products.add(product);
    notifyListeners();
    return 'exito';
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dzz31k0ef/image/upload?upload_preset=p3wb9jcp');
    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);
    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamResponse);

    if (response.statusCode != 200 && response.statusCode != 201) {
      print('Algo Salio Mal ${response.body}');
      return null;
    }
    this.newPictureFile = null;
    final decodedData = jsonDecode(response.body);
    return decodedData['secure_url'];
  }
}
