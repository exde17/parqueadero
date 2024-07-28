import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key}); // Agrega el parámetro key al constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EmpowerApp'),
      ),
      body: const Center(
        child: Text('Contenido de la pantalla principal'),
      ),
      bottomNavigationBar: const CustonBottomNavigation(
        // selectedIndex: 0, // Puedes cambiar esto según sea necesario
        onItemTapped: null, // Puedes definir una función aquí si es necesario
      ),
    );
  }
}

// class CustonBottomNavigation extends StatelessWidget {
//   final int selectedIndex;
//   final void Function(int)? onItemTapped;

//   const CustonBottomNavigation({
//     Key? key,
//     required this.selectedIndex,
//     required this.onItemTapped,
//   }) : super(key: key); // Agrega el parámetro key al constructor

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       items: const <BottomNavigationBarItem>[
//         BottomNavigationBarItem(
//             icon: Icon(Icons.visibility), label: 'Visibilizate'),
//         BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Empleate'),
//         BottomNavigationBarItem(
//             icon: Icon(Icons.room_service), label: 'Servicios'),
//       ],
//       currentIndex: selectedIndex,
//       selectedItemColor: Colors.amber[800], // Color seleccionado
//       onTap: onItemTapped,
//     );
//   }
// }

class CustonBottomNavigation extends StatefulWidget {
  final void Function(int)? onItemTapped;

  const CustonBottomNavigation({
    super.key,
    required this.onItemTapped,
  }); // Agrega el parámetro key al constructor

  @override
  CustonBottomNavigationState createState() => CustonBottomNavigationState();
}

class CustonBottomNavigationState extends State<CustonBottomNavigation> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Diario'),
        BottomNavigationBarItem(icon: Icon(Icons.add_task_rounded), label: 'Alquiler'),
        BottomNavigationBarItem(
            icon: Icon(Icons.insights_sharp), label: 'proximo'),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800], // Color seleccionado
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        if (widget.onItemTapped != null) {
          widget.onItemTapped!(index);
        }
      },
    );
  }
}
