import 'package:flutter/material.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(AppState());

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
      ChangeNotifierProvider( create: (context) => ProductsService()),
      ChangeNotifierProvider( create: (context) => AuthService()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: CheckAuthScreen.routeCheckAuthScreen,
      scaffoldMessengerKey: NotificationsService.messengerKey,
      routes: {
        LoginScreen.loginRoute: (_) => const LoginScreen(),
        RegisterScreen.registerRoute: (_) => const RegisterScreen(),
        HomeScreen.homeRoute: (_) => const HomeScreen(),
        ProductScreen.productRoute: (_) => const ProductScreen(),
        CheckAuthScreen.routeCheckAuthScreen: (_) => const CheckAuthScreen(),
      },
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[300],
          appBarTheme: const AppBarTheme(elevation: 0, color: Colors.indigo),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.indigo, elevation: 0)),
    );
  }
}
