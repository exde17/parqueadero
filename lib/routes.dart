import 'package:flutter/material.dart';
// import 'package:http/http.dart';
import 'package:parqueadero/src/screen/alquiler.dart';
import 'package:parqueadero/src/screen/clientes.dart';
import 'package:parqueadero/src/screen/configuracion.dart';
import 'package:parqueadero/src/screen/history.dart';
import 'package:parqueadero/src/screen/historyAlquiler.dart';
import 'package:parqueadero/src/screen/home.dart';
import 'package:parqueadero/src/screen/listarClientesDiarios.dart';
import 'package:parqueadero/src/screen/login.dart';
import 'package:parqueadero/src/screen/register.dart';
// import 'package:parqueadero/src/screen/clientes.dart';

class Routes {
  static const String home = '/';
  static const String register = '/register';
  static const String login = '/login';
  static const String cliente = '/cliente';
  static const String historial = '/historial';
  static const String alquiler = '/alquiler';
  static const String histiryAlquiler = '/historyAlquiler';
  static const String configuracion = '/configuracion';
  static const String listClientes = '/listClientes';

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
      case historial:
        return MaterialPageRoute(builder: (_) => const Historial()); 
      case alquiler:
        return MaterialPageRoute(builder: (_) => const AlquileresPage());
      case histiryAlquiler:
        return MaterialPageRoute(builder: (_) => const HistoryAlquiler());
      case configuracion:
        return MaterialPageRoute(builder: (_) => const ConfiguracionScreen());  
      case listClientes:
        return MaterialPageRoute(builder: (_) => const ClienteListWidget());       
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
