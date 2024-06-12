import 'package:flutter/material.dart';
import 'package:parqueadero/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: const Color.fromARGB(255, 29, 8, 188)),
      initialRoute: Routes.login,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
