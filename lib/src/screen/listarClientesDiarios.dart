// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:parqueadero/src/utils/config.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ClienteListWidget extends StatefulWidget {
//   const ClienteListWidget({super.key});

//   @override
//   _ClienteListWidgetState createState() => _ClienteListWidgetState();
// }

// class _ClienteListWidgetState extends State<ClienteListWidget> {
//   List<Cliente> clientes = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchClientes();
//   }

//   Future<void> fetchClientes() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? token = prefs.getString('auth_token');

//     if (token == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Error: Token no encontrado')),
//       );
//       return;
//     }

//     EasyLoading.show(status: 'Cargando...');

//     final Uri url = Uri.parse('${GlobalConfig.apiHost}:3000/api/cliente');
//     final headers = {
//       "Content-Type": "application/json",
//       "Authorization": "Bearer $token",
//     };
//     try {
//       final response = await http.get(url, headers: headers);

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           clientes = data
//               .map((json) => Cliente.fromJson(json))
//               .where((cliente) => cliente.isActive)
//               .toList();
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Error al cargar los clientes')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Error de conexión. Inténtalo de nuevo.')),
//       );
//     } finally {
//       EasyLoading.dismiss();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Lista de Clientes")),
//       body: clientes.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: clientes.length,
//               itemBuilder: (context, index) {
//                 final cliente = clientes[index];

//                 return GestureDetector(
//                   onTap: () {
//                     debugPrint("Cliente seleccionado: ${cliente.nombre}");
//                   },
//                   child: Card(
//                     margin: const EdgeInsets.symmetric(
//                         vertical: 8, horizontal: 16),
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15)),
//                     child: ListTile(
//                       contentPadding: const EdgeInsets.all(16),
//                       leading: CircleAvatar(
//                         backgroundColor:
//                             cliente.pago ? Colors.green : Colors.red,
//                         child: Icon(
//                           cliente.pago ? Icons.check_circle : Icons.warning,
//                           color: Colors.white,
//                         ),
//                       ),
//                       title: Text(
//                         "${cliente.nombre} ${cliente.apellido ?? ''}",
//                         style: const TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold),
//                       ),

//                       trailing: const Icon(Icons.arrow_forward_ios),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

// class Cliente {
//   final String id;
//   final String nombre;
//   final String? apellido;
//   final bool isActive;
//   final bool pago;

//   Cliente({
//     required this.id,
//     required this.nombre,
//     this.apellido,
//     required this.isActive,
//     required this.pago,
//   });

//   factory Cliente.fromJson(Map<String, dynamic> json) {
//     return Cliente(
//       id: json['id'] ?? '',
//       nombre: json['nombre'] ?? '',
//       apellido: json['apellido'],
//       isActive: json['isActive'] ?? true,
//       pago: json['pago'] ?? false,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:parqueadero/routes.dart';
import 'package:parqueadero/src/screen/listarPagos.dart';
import 'package:parqueadero/src/utils/bar.dart';
import 'package:parqueadero/src/utils/bottom_navigation.dart.dart';
import 'package:parqueadero/src/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClienteListWidget extends StatefulWidget {
  const ClienteListWidget({super.key});

  @override
  _ClienteListWidgetState createState() => _ClienteListWidgetState();
}

class _ClienteListWidgetState extends State<ClienteListWidget> {
  List<Cliente> clientes = [];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.pushNamed(context, Routes.cliente);
      }
      if (index == 1) {
        Navigator.pushNamed(context, Routes.alquiler);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchClientes();
  }

  Future<void> fetchClientes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Token no encontrado')),
      );
      return;
    }

    EasyLoading.show(status: 'Cargando...');

    final Uri url = Uri.parse('${GlobalConfig.apiHost}:3000/api/cliente');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          clientes = data
              .map((json) => Cliente.fromJson(json))
              .where((cliente) => cliente.isActive)
              .toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar los clientes')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión. Inténtalo de nuevo.')),
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  // ✅ FUNCIÓN PARA MOSTRAR EL DIÁLOGO CUANDO SE TOCA UN CLIENTE
  void _mostrarOpcionesCliente(BuildContext context, Cliente cliente) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Opciones para ${cliente.nombre}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.attach_money, color: Colors.green),
                title: const Text("Pagos"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PagosClienteWidget(clientId: cliente.id)),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.warning, color: Colors.red),
                title: const Text("Deudas"),
                onTap: () {
                  
                },
              ),
              ListTile(
                leading: const Icon(Icons.forward, color: Colors.blue),
                title: const Text("Adelantos"),
                onTap: () {
                  Navigator.pop(context);
                  debugPrint("Adelantos seleccionados para ${cliente.nombre}");
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

  void _navigateToHistorial(BuildContext context) {
    Navigator.pushNamed(context, Routes.configuracion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Lista de Clientes")),
      appBar: CustomAppBar.buildAppBar(
          context, () => _navigateToHistorial(context)),
      body: clientes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, index) {
                final cliente = clientes[index];

                return GestureDetector(
                  onTap: () {
                    _mostrarOpcionesCliente(context, cliente);
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor:
                            cliente.pago ? Colors.green : Colors.red,
                        child: Icon(
                          cliente.pago ? Icons.check_circle : Icons.warning,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        "${cliente.nombre} ${cliente.apellido ?? ''}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: CustonBottomNavigation(
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class Cliente {
  final String id;
  final String nombre;
  final String? apellido;
  final bool isActive;
  final bool pago;

  Cliente({
    required this.id,
    required this.nombre,
    this.apellido,
    required this.isActive,
    required this.pago,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'],
      isActive: json['isActive'] ?? true,
      pago: json['pago'] ?? false,
    );
  }
}
