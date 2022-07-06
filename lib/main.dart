import 'package:flutter/material.dart';
import 'package:productos_app/screens/screens.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'login',
      routes: {
        LoginScreen.loginRoute: (_) => LoginScreen(),
        HomeScreen.homeRoute: (_) => HomeScreen(),
      },
      theme: ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.grey[300]),
    );
  }
}