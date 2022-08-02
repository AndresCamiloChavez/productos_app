import 'package:flutter/material.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
  static String routeCheckAuthScreen = 'checkAuth';
  const CheckAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: FutureBuilder(
        future: authService.isAuthenticate(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (!snapshot.hasData)
            return const Center(child: Text('Espere por favor'));

          if (snapshot.data == '') {
            Future.microtask(() {
              // Navigator.pushReplacementNamed(context, LoginScreen.loginRoute);
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (context, animaci1, anima2) {
                        return const LoginScreen();
                      },
                      transitionDuration: const Duration(seconds: 0)));
            });
          } else {
            Future.microtask(() {
              // Navigator.pushReplacementNamed(context, LoginScreen.loginRoute);
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (context, animaci1, anima2) {
                        return const HomeScreen();
                      },
                      transitionDuration: const Duration(seconds: 0)));
            });
          }
          return Container();
        },
      ),
    );
  }
}
