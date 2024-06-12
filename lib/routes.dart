import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:parqueadero/src/screen/clientes.dart';
import 'package:parqueadero/src/screen/home.dart';
import 'package:parqueadero/src/screen/login.dart';
import 'package:parqueadero/src/screen/register.dart';
// import 'package:parqueadero/src/screen/clientes.dart';

class Routes {
  static const String home = '/';
  static const String register = '/register';
  static const String login = '/login';
  static const String cliente = '/cliente';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const Home());
      case register:
        return MaterialPageRoute(builder: (_) => const Register());
      case login:
        return MaterialPageRoute(builder: (_) => const Login());
      case cliente:
        return MaterialPageRoute(builder: (_) => const ClienteListPage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
