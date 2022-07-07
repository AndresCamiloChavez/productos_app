import 'package:flutter/material.dart';

import '../models/models.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> form = GlobalKey<FormState>();
  Product product;

  set isAvailable(bool isAvailableValue) {
    product.available = isAvailableValue;
    notifyListeners();
  }

  ProductFormProvider(this.product);

  bool isValidForm() {
    print('product ${product.name} ${product.available} ${product.price}');
    return form.currentState?.validate() ?? false;
  }
}
