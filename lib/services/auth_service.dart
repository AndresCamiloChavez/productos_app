import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyDHE5pVTVriflIPIS299cr_1SH8JXqaCIA';
  final _storage = const FlutterSecureStorage();
// si retornamos algo quiere decir que ocurrió un error, si no no!
  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true

    };
    final url =
        Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firebaseToken});
    final response = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodedResp = jsonDecode(response.body);
    print(decodedResp);
    if (response.statusCode == 200 || response.statusCode == 201) {
      //Hay que guardar token
      // return decodedResp['idToken'];
      await _storage.write(key: 'token', value: decodedResp['idToken']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    final url = Uri.https(
        _baseUrl, '/v1/accounts:signInWithPassword', {'key': _firebaseToken});
    final response = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodedResp = jsonDecode(response.body);

    print('desde el login -> $decodedResp');
    if (response.statusCode == 200 || response.statusCode == 201) {
      //Hay que guardar token
      // return decodedResp['idToken'];
      await _storage.write(key: 'token', value: decodedResp['idToken']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future logout() async {
    await _storage.delete(key: 'token');
    return;
  }

  Future<String> isAuthenticate() async {
    return await _storage.read(key: 'token') ?? '';
  }
}
