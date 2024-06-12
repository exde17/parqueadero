// import 'package:flutter/material.dart';
// import 'package:parqueadero/routes.dart';
// import 'package:parqueadero/src/utils/bar.dart';
// import 'package:parqueadero/src/utils/bottom_navigation.dart.dart';

// // Modelo de Cliente
// class Cliente {
//   final String nombre;
//   final bool pagoCompleto;
//   final bool pagoParcial;

//   Cliente({
//     required this.nombre,
//     required this.pagoCompleto,
//     required this.pagoParcial,
//   });
// }

// void main() {
//   runApp(const MaterialApp(
//     home: ClienteListPage(),
//   ));
// }

// class ClienteListPage extends StatefulWidget {
//   const ClienteListPage({super.key});

//   @override
//   _ClienteListPageState createState() => _ClienteListPageState();
// }

// class _ClienteListPageState extends State<ClienteListPage> {
//   int _selectedIndex = 0; // Estado para rastrear el ítem seleccionado

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//       // Verifica qué ítem se seleccionó y navega a la pantalla correspondiente
//       if (index == 0) {
//         Navigator.pushNamed(context, Routes.register);
//       }
//       if (index == 1) {
//         Navigator.pushNamed(context, Routes.home);
//       }
//     });
//   }

//   List<Cliente> clientes = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchClientes();
//   }

//   // Función simulada para consumir un endpoint
//   Future<void> fetchClientes() async {
//     // Aquí iría el código para consumir el endpoint real.
//     // Por ahora llenamos la lista con datos de ejemplo.
//     setState(() {
//       clientes = [
//         Cliente(nombre: 'Cliente 1', pagoCompleto: true, pagoParcial: false),
//         Cliente(nombre: 'Cliente 2', pagoCompleto: false, pagoParcial: true),
//         Cliente(nombre: 'Cliente 3', pagoCompleto: false, pagoParcial: false),
//       ];
//     });
//   }

//   // Función para manejar la creación de un nuevo cliente
//   void crearCliente() {
//     // Aquí iría el código para crear un nuevo cliente
//   }

//   // Función para ver detalles de un cliente
//   void verDetalle(Cliente cliente) {
//     // Aquí iría el código para ver los detalles del cliente
//   }

//   // Función para manejar el pago de un cliente
//   void registrarPago(Cliente cliente, bool completo) {
//     // Aquí iría el código para registrar el pago del cliente
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: CustomAppBar.buildAppBar(context),
//         body: ListView.builder(
//           itemCount: clientes.length,
//           itemBuilder: (context, index) {
//             final cliente = clientes[index];
//             return Card(
//               child: ListTile(
//                 title: Text(cliente.nombre),
//                 subtitle: Text(
//                   cliente.pagoCompleto
//                       ? 'Pago Completo'
//                       : cliente.pagoParcial
//                           ? 'Pago Parcial'
//                           : 'Sin Pago',
//                 ),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.details),
//                       onPressed: () => verDetalle(cliente),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.payment),
//                       onPressed: () => registrarPago(cliente, true),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.payment_outlined),
//                       onPressed: () => registrarPago(cliente, false),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: crearCliente,
//           tooltip: 'Crear Cliente',
//           child: const Icon(Icons.add),
//         ),
//         bottomNavigationBar: CustonBottomNavigation(
//           // selectedIndex: _selectedIndex,
//           onItemTapped: _onItemTapped,
//         ));
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:parqueadero/routes.dart';
import 'package:parqueadero/src/utils/bar.dart';
import 'package:parqueadero/src/utils/bottom_navigation.dart.dart';
import 'package:parqueadero/src/utils/toast.dart';

// Modelo de Cliente
class Cliente {
  final String nombre;
  final String? apellido;
  final String? guarda;
  final String? telefono;
  final String? documento;
  final double valor;
  final bool pagoCompleto;
  final bool pagoParcial;
  final bool isActive;

  Cliente({
    required this.nombre,
    this.apellido,
    this.guarda,
    this.telefono,
    this.documento,
    required this.valor,
    required this.pagoCompleto,
    required this.pagoParcial,
    required this.isActive, // Inicializa el nuevo campo
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'],
      guarda: json['guarda'],
      telefono: json['telefono'],
      documento: json['documento'],
      valor: (json['valor'] ?? 0).toDouble(),
      pagoCompleto: json['pagoCompleto'] ?? false,
      pagoParcial: json['pagoParcial'] ?? false,
      isActive: json['isActive'] ?? true, // Asigna el valor del campo isActive
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ClienteListPage(),
  ));
}

class ClienteListPage extends StatefulWidget {
  const ClienteListPage({super.key});

  @override
  _ClienteListPageState createState() => _ClienteListPageState();
}

class _ClienteListPageState extends State<ClienteListPage> {
  int _selectedIndex = 0; // Estado para rastrear el ítem seleccionado

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Verifica qué ítem se seleccionó y navega a la pantalla correspondiente
      if (index == 0) {
        Navigator.pushNamed(context, Routes.register);
      }
      if (index == 1) {
        Navigator.pushNamed(context, Routes.home);
      }
    });
  }

  List<Cliente> clientes = [];

  @override
  void initState() {
    super.initState();
    fetchClientes();
  }

  // Función para consumir el endpoint y obtener la lista de clientes
  Future<void> fetchClientes() async {
    final Uri url = Uri.parse('http://10.0.2.2:3000/api/cliente');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          clientes = data
              .map((json) => Cliente.fromJson(json))
              .where((cliente) => cliente.isActive)
              .toList();
          // clientes = data.map((json) => Cliente.fromJson(json)).toList();
        });
      } else {
        showCustomToastWithIcon(context, 'Error al cargar los clientes');
      }
    } catch (e) {
      showCustomToastWithIcon(
          context, 'Error de conexión. Inténtalo de nuevo.');
    }
  }

  // Función para manejar la creación de un nuevo cliente
  void crearCliente() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _formKey = GlobalKey<FormState>();
        final _nombreController = TextEditingController();
        final _valorController = TextEditingController();
        final _apellidoController = TextEditingController();
        final _guardaController = TextEditingController();
        final _telefonoController = TextEditingController();
        final _documentoController = TextEditingController();

        return AlertDialog(
          title: const Text('Crear Cliente'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el nombre';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _valorController,
                    decoration: const InputDecoration(labelText: 'Valor'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el valor';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _apellidoController,
                    decoration: const InputDecoration(labelText: 'Apellido'),
                  ),
                  TextFormField(
                    controller: _guardaController,
                    decoration: const InputDecoration(labelText: 'Guarda'),
                  ),
                  TextFormField(
                    controller: _telefonoController,
                    decoration: const InputDecoration(labelText: 'Teléfono'),
                    keyboardType: TextInputType.phone,
                  ),
                  TextFormField(
                    controller: _documentoController,
                    decoration: const InputDecoration(labelText: 'Documento'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Guardar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  saveCliente(
                    _nombreController.text,
                    double.parse(_valorController.text),
                    _apellidoController.text,
                    _guardaController.text,
                    _telefonoController.text,
                    _documentoController.text,
                    context,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> saveCliente(
    String nombre,
    double valor,
    String? apellido,
    String? guarda,
    String? telefono,
    String? documento,
    BuildContext context,
  ) async {
    final Uri url = Uri.parse('http://10.0.2.2:3000/api/cliente');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nombre': nombre,
          'valor': valor,
          'apellido': apellido,
          'guarda': guarda,
          'telefono': telefono,
          'documento': documento,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.of(context).pop();
        showCustomToastWithIcon(context, 'Cliente creado exitosamente');
        fetchClientes();
      } else {
        var responseBody = response.body;
        var decodedResponse = jsonDecode(responseBody);
        String message = decodedResponse['message'];
        showCustomToastWithIcon(context, message);
      }
    } catch (e) {
      showCustomToastWithIcon(
          context, 'Error al crear el cliente. Inténtalo de nuevo.');
    }
  }

  // Función para ver detalles de un cliente
  void verDetalle(Cliente cliente) {
    // Aquí iría el código para ver los detalles del cliente
  }

  // Función para manejar el pago de un cliente
  void registrarPago(Cliente cliente, bool completo) {
    // Aquí iría el código para registrar el pago del cliente
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.buildAppBar(context),
      body: ListView.builder(
        itemCount: clientes.length,
        itemBuilder: (context, index) {
          final cliente = clientes[index];
          return Card(
            child: ListTile(
              title: Text('${cliente.nombre} ${cliente.apellido ?? ''}'),
              subtitle: Text(
                cliente.pagoCompleto
                    ? 'Pago Completo'
                    : cliente.pagoParcial
                        ? 'Pago Parcial'
                        : 'Sin Pago',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.details),
                    onPressed: () => verDetalle(cliente),
                  ),
                  IconButton(
                    icon: const Icon(Icons.payment),
                    onPressed: () => registrarPago(cliente, true),
                  ),
                  IconButton(
                    icon: const Icon(Icons.payment_outlined),
                    onPressed: () => registrarPago(cliente, false),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: crearCliente,
        tooltip: 'Crear Cliente',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: CustonBottomNavigation(
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
