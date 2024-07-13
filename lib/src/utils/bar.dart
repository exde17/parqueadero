// import 'dart:js';

// import 'package:empower_app/rutes.dart';
import 'package:flutter/material.dart';
import 'package:parqueadero/routes.dart';

class CustomAppBar {
  static AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,

      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Parqueadero la 34',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.07,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 6, 21, 158),
            ),
          ),
          const SizedBox(width: 10),
          // Image.asset(
          //   'lib/assets/logoEmpowerapp.png',
          //   width: MediaQuery.of(context).size.width * 0.08,
          //   height: MediaQuery.of(context).size.width * 0.08,
          // ),
        ],
      ),
      centerTitle: true,
      //boton de opciones
      leading: IconButton(
        icon: Icon(Icons.home, size: MediaQuery.of(context).size.width * 0.08),
        color: Colors.blue,
        onPressed: () {
          Navigator.pushNamed(context, Routes.cliente);
        },
      ),

      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: (String value) {
            if (value == 'perfil') {
              // Navega a la pantalla de perfil
            } else if (value == 'cerrar_sesion') {
              Navigator.pushReplacementNamed(context, Routes.login);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'perfil',
              child: Text('Perfil'),
            ),
            const PopupMenuItem<String>(
              value: 'cerrar_sesion',
              child: Text('Cerrar sesión'),
            ),
          ],
          icon: Icon(Icons.person,
              size: MediaQuery.of(context).size.width * 0.08),
              // color: Colors.blue,
        ),
      ],
    );
  }
}
