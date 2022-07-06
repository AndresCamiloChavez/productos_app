import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool isLoadingValue) {
    _isLoading = isLoadingValue;
    notifyListeners();
  }

  bool isValidForm() {
    print('Valor del formkey ${formKey.currentState?.validate()}');
    return formKey.currentState?.validate() ?? false;
  }
}
