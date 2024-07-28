// import 'package:ingresos_egresos/rutes.dart';
// import 'package:empower_app/src/screens/empleate/empleate.dart';
import 'package:flutter/material.dart';
import 'package:parqueadero/routes.dart';
import 'package:parqueadero/src/utils/bar.dart';
import 'package:parqueadero/src/utils/bottom_navigation.dart.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _selectedIndex = 0; // Estado para rastrear el ítem seleccionado

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Verifica qué ítem se seleccionó y navega a la pantalla correspondiente
      if (index == 0) {
        Navigator.pushNamed(context, Routes.register);
      }
      if (index == 1) {
        Navigator.pushNamed(context, Routes.cliente);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizedBox(height: MediaQuery.of(context).size.height * 0.02);
    return Scaffold(
        // appBar: CustomAppBar.buildAppBar(context),
        body: const Center(
          child: Center(
            child: Text('Home'),
          ),
        ),
        bottomNavigationBar: CustonBottomNavigation(
          // selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ));
  }
}
