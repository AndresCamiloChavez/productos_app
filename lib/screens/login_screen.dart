import 'package:flutter/material.dart';
import 'package:productos_app/providers/login_form_provider.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../ui/input_decoration.dart';

class LoginScreen extends StatelessWidget {
  static const String loginRoute = 'login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackgorund(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 220,
            ),
            CardContainer(
                child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(
                  height: 30,
                ),
                ChangeNotifierProvider(
                    create: (context) => LoginFormProvider(),
                    child: const _LoginForm())
              ],
            )),
            const SizedBox(
              height: 150,
            ),
            const Text(
              'Crear una nueva cuenta',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    ));
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginFromProvider = Provider.of<LoginFormProvider>(context);
    return Container(
      child: Form(
          //TODO: tener la referencia al Key
          key: loginFromProvider.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'example@email.com',
                    labelText: 'Corre electrónico',
                    prefixIcon: Icons.alternate_email_sharp),
                onChanged: (value) {
                  loginFromProvider.email = value;
                },
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = new RegExp(pattern);
                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'Correo no válido';
                },
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '*******',
                    labelText: 'Contraseña',
                    prefixIcon: Icons.password_sharp),
                onChanged: (value) => loginFromProvider.password = value,
                validator: (value) {
                  if (value != null && value.length >= 6) return null;
                  return 'Contraseña no válida';
                },
              ),
              const SizedBox(
                height: 30,
              ),
              MaterialButton(
                onPressed: loginFromProvider.isLoading
                    ? null
                    : () async {
                        if (!loginFromProvider.isValidForm()) return;
                        FocusScope.of(context).unfocus();
                        loginFromProvider.isLoading = true;

                        await Future.delayed(Duration(milliseconds: 2000));
                        loginFromProvider.isLoading = false;
                        // Navigator.pushReplacementNamed(context, HomeScreen.homeRoute);
                      },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.deepPurpleAccent,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                    loginFromProvider.isLoading ? 'Cargando...' : 'Ingresar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
