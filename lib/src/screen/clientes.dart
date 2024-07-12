// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:parqueadero/routes.dart';
// import 'package:parqueadero/src/utils/bar.dart';
// import 'package:parqueadero/src/utils/bottom_navigation.dart.dart';
// import 'package:parqueadero/src/utils/toast.dart';
// import 'package:logger/logger.dart';

// final TextEditingController _paymentController = TextEditingController();
// var logger = Logger();

// // Modelo de Cliente
// class Cliente {
//   final String id;
//   final String nombre;
//   final String? apellido;
//   final String? guarda;
//   final String? telefono;
//   final String? documento;
//   final double valor;
//   // final bool pagoCompleto;
//   // final bool pagoParcial;
//   final bool isActive;
//   final bool novedad;
//   final bool pago;

//   Cliente({
//     required this.nombre,
//     required this.id,
//     this.apellido,
//     this.guarda,
//     this.telefono,
//     this.documento,
//     required this.valor,
//     // required this.pagoCompleto,
//     // required this.pagoParcial,
//     required this.isActive, // Inicializa el nuevo campo
//     required this.novedad,
//     required this.pago,
//   });

//   factory Cliente.fromJson(Map<String, dynamic> json) {
//     return Cliente(
//       id: json['id'] ?? '',
//       nombre: json['nombre'] ?? '',
//       apellido: json['apellido'],
//       guarda: json['guarda'],
//       telefono: json['telefono'],
//       documento: json['documento'],
//       valor: (json['valor'] ?? 0).toDouble(),
//       // pagoCompleto: json['pagoCompleto'] ?? false,
//       // pagoParcial: json['pagoParcial'] ?? false,
//       isActive: json['isActive'] ?? true, // Asigna el valor del campo isActive
//       novedad: json['novedad'] ?? false,
//       pago: json['pago'] ?? false,
//     );
//   }
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

//   // Función para consumir el endpoint y obtener la lista de clientes
//   Future<void> fetchClientes() async {
//     final Uri url = Uri.parse('http://10.0.2.2:3000/api/cliente');
//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           clientes = data
//               .map((json) => Cliente.fromJson(json))
//               .where((cliente) => cliente.isActive)
//               .toList();
//           // clientes = data.map((json) => Cliente.fromJson(json)).toList();
//         });
//       } else {
//         showCustomToastWithIcon(context, 'Error al cargar los clientes');
//       }
//     } catch (e) {
//       showCustomToastWithIcon(
//           context, 'Error de conexión. Inténtalo de nuevo.');
//     }
//   }

//   // Función para manejar la creación de un nuevo cliente
//   void crearCliente() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         final formKey = GlobalKey<FormState>();
//         final nombreController = TextEditingController();
//         final valorController = TextEditingController();
//         final apellidoController = TextEditingController();
//         final guardaController = TextEditingController();
//         final telefonoController = TextEditingController();
//         final documentoController = TextEditingController();

//         return AlertDialog(
//           title: const Text('Crear Cliente'),
//           content: Form(
//             key: formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: nombreController,
//                     decoration: const InputDecoration(labelText: 'Nombre'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Por favor ingrese el nombre';
//                       }
//                       return null;
//                     },
//                   ),
//                   TextFormField(
//                     controller: valorController,
//                     decoration: const InputDecoration(labelText: 'Valor'),
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Por favor ingrese el valor';
//                       }
//                       return null;
//                     },
//                   ),
//                   TextFormField(
//                     controller: apellidoController,
//                     decoration: const InputDecoration(labelText: 'Apellido'),
//                   ),
//                   TextFormField(
//                     controller: guardaController,
//                     decoration: const InputDecoration(labelText: 'Guarda'),
//                   ),
//                   TextFormField(
//                     controller: telefonoController,
//                     decoration: const InputDecoration(labelText: 'Teléfono'),
//                     keyboardType: TextInputType.phone,
//                   ),
//                   TextFormField(
//                     controller: documentoController,
//                     decoration: const InputDecoration(labelText: 'Documento'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               child: const Text('Cancelar'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             ElevatedButton(
//               child: const Text('Guardar'),
//               onPressed: () {
//                 if (formKey.currentState!.validate()) {
//                   saveCliente(
//                     nombreController.text,
//                     double.parse(valorController.text),
//                     apellidoController.text,
//                     guardaController.text,
//                     telefonoController.text,
//                     documentoController.text,
//                     context,
//                   );
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> saveCliente(
//     String nombre,
//     double valor,
//     String? apellido,
//     String? guarda,
//     String? telefono,
//     String? documento,
//     BuildContext context,
//   ) async {
//     final Uri url = Uri.parse('http://10.0.2.2:3000/api/cliente');
//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'nombre': nombre,
//           'valor': valor,
//           'apellido': apellido,
//           'guarda': guarda,
//           'telefono': telefono,
//           'documento': documento,
//         }),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         Navigator.of(context).pop();
//         showCustomToastWithIcon(context, 'Cliente creado exitosamente');
//         fetchClientes();
//       } else {
//         var responseBody = response.body;
//         var decodedResponse = jsonDecode(responseBody);
//         String message = decodedResponse['message'];
//         showCustomToastWithIcon(context, message);
//       }
//     } catch (e) {
//       showCustomToastWithIcon(
//           context, 'Error al crear el cliente. Inténtalo de nuevo.');
//     }
//   }

//   // Función para ver detalles de un cliente
//   void verDetalle(Cliente cliente) {
//     // Aquí iría el código para ver los detalles del cliente
//   }

//   // Función para manejar el pago de un cliente
//   void registrarPago(Cliente cliente, bool completo) {
//     // Aquí iría el código para registrar el pago del cliente
//     // Puedes agregar la lógica necesaria para manejar el pago
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar.buildAppBar(context),
//       body: ListView.builder(
//         itemCount: clientes.length,
//         itemBuilder: (context, index) {
//           final cliente = clientes[index];
//           return Card(
//             //////////
//             child: ListTile(
//               title: Text('${cliente.nombre} ${cliente.apellido ?? ''}'),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Mostrar valor a pagar si el cliente no ha pagado
//                   if (!cliente.pago) Text('Valor a pagar: \$${cliente.valor}'),
//                   // Mostrar estado de pago
//                   Text(
//                     cliente.pago ? 'Pago' : 'Sin Pago',
//                     style: TextStyle(
//                       // Cambiar el color del texto según las condiciones
//                       color: cliente.pago
//                           ? (cliente.novedad ? Colors.red : Colors.green)
//                           : Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     Icons.sync,
//                     // Cambiar el color del ícono según las condiciones
//                     color: cliente.pago
//                         ? (cliente.novedad ? Colors.red : Colors.green)
//                         : Colors.grey,
//                   ),
                  
//                   IconButton(
//                     icon: const Icon(Icons.monetization_on),
//                     onPressed: cliente.pago && !cliente.novedad
//                         ? null
//                         : () => _mostrarModalYRegistrarPago(
//                             context, cliente.id, cliente.valor),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: crearCliente,
//         tooltip: 'Crear Cliente',
//         child: const Icon(Icons.add),
//       ),
//       bottomNavigationBar: CustonBottomNavigation(
//         onItemTapped: _onItemTapped,
//       ),
//     );
//   }

// // Función para mostrar el modal y registrar el pago

//   void _mostrarModalYRegistrarPago(
//       BuildContext context, String clienteId, double valor) {
//     // Paso 1: Crear el TextEditingController
//     final TextEditingController valorController =
//         TextEditingController(text: valor.toString());

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         // Aquí construyes el contenido del modal
//         return AlertDialog(
//           title: const Text('Guardar Pago'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text('ID del Cliente: $clienteId'),
//                 // Paso 2: Usar un TextField para permitir la modificación del valor
//                 TextField(
//                   controller: valorController,
//                   decoration: const InputDecoration(
//                     labelText: 'Valor',
//                   ),
//                   keyboardType: TextInputType.numberWithOptions(decimal: true),
//                 ),
//                 // Aquí puedes añadir más widgets para capturar más información si es necesario
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancelar'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Guardar'),
//               onPressed: () {
//                 // Paso 3: Utilizar el valor del TextEditingController
//                 double valorModificado =
//                     double.tryParse(valorController.text) ?? valor;
//                 realizarPago(context, datosPago(valorModificado, clienteId));
//                 Navigator.of(context).pop();

//                 fetchClientes();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

// // Función para realizar una solicitud POST al endpoint de pago
//   Future<void> realizarPago(
//       BuildContext context, Map<String, dynamic> datosPago) async {
//     // BuildContext context;
//     final url = Uri.parse('http://10.0.2.2:3000/api/pago-total');
//     final headers = {"Content-Type": "application/json"};
//     final body = json.encode(datosPago);

//     try {
//       final response = await http.post(url, headers: headers, body: body);
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // Si el servidor devuelve una respuesta OK, procesamos el JSON.
//         logger.i("Pago realizado con éxito");
//         // ignore: use_build_context_synchronously
//         showCustomToastWithIcon(context, 'Cliente creado exitosamente');
//       } else {
//         // Si el servidor no devuelve una respuesta OK, lanzamos un error.
//         logger.e("Error al realizar el pago: ${response.body}");
//       }
//     } catch (e) {
//       logger.e("Error al conectar al servidor: $e");
//     }
//   }

//   Map<String, dynamic> datosPago(double valor, String cliente) {
//     // Asegúrate de validar o manejar adecuadamente los valores nulos o inválidos
//     if (valor == null || cliente == null || cliente.isEmpty) {
//       throw ArgumentError(
//           'El valor y el cliente no pueden ser nulos o vacíos.');
//     }
//     return {
//       'valor': valor,
//       'cliente': cliente,
//     };
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:parqueadero/routes.dart';
import 'package:parqueadero/src/utils/bar.dart';
import 'package:parqueadero/src/utils/bottom_navigation.dart.dart';
import 'package:parqueadero/src/utils/toast.dart';
import 'package:logger/logger.dart';

final TextEditingController _paymentController = TextEditingController();
var logger = Logger();

// Modelo de Cliente
class Cliente {
  final String id;
  final String nombre;
  final String? apellido;
  final String? guarda;
  final String? telefono;
  final String? documento;
  final double valor;
  final bool isActive;
  final bool novedad;
  final bool pago;

  Cliente({
    required this.nombre,
    required this.id,
    this.apellido,
    this.guarda,
    this.telefono,
    this.documento,
    required this.valor,
    required this.isActive,
    required this.novedad,
    required this.pago,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'],
      guarda: json['guarda'],
      telefono: json['telefono'],
      documento: json['documento'],
      valor: (json['valor'] ?? 0).toDouble(),
      isActive: json['isActive'] ?? true,
      novedad: json['novedad'] ?? false,
      pago: json['pago'] ?? false,
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
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
        });
      } else {
        showCustomToastWithIcon(context, 'Error al cargar los clientes');
      }
    } catch (e) {
      showCustomToastWithIcon(
          context, 'Error de conexión. Inténtalo de nuevo.');
    }
  }

  void crearCliente() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final formKey = GlobalKey<FormState>();
        final nombreController = TextEditingController();
        final valorController = TextEditingController();
        final apellidoController = TextEditingController();
        final guardaController = TextEditingController();
        final telefonoController = TextEditingController();
        final documentoController = TextEditingController();

        return AlertDialog(
          title: const Text('Crear Cliente'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nombreController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el nombre';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: valorController,
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
                    controller: apellidoController,
                    decoration: const InputDecoration(labelText: 'Apellido'),
                  ),
                  TextFormField(
                    controller: guardaController,
                    decoration: const InputDecoration(labelText: 'Guarda'),
                  ),
                  TextFormField(
                    controller: telefonoController,
                    decoration: const InputDecoration(labelText: 'Teléfono'),
                    keyboardType: TextInputType.phone,
                  ),
                  TextFormField(
                    controller: documentoController,
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
                if (formKey.currentState!.validate()) {
                  saveCliente(
                    nombreController.text,
                    double.parse(valorController.text),
                    apellidoController.text,
                    guardaController.text,
                    telefonoController.text,
                    documentoController.text,
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

  void verDetalle(Cliente cliente) {
    // Aquí iría el código para ver los detalles del cliente
  }

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
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!cliente.pago) Text('Valor a pagar: \$${cliente.valor}'),
                  Text(
                    cliente.pago ? 'Pago' : 'Sin Pago',
                    style: TextStyle(
                      color: cliente.pago
                          ? (cliente.novedad ? Colors.red : Colors.green)
                          : Colors.black,
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.sync,
                    color: cliente.pago
                        ? (cliente.novedad ? Colors.red : Colors.green)
                        : Colors.grey,
                  ),
                  IconButton(
                    icon: const Icon(Icons.monetization_on),
                    onPressed: cliente.pago && !cliente.novedad
                        ? null
                        : () => _mostrarModalYRegistrarPago(
                            context, cliente.id, cliente.valor),
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

  void _mostrarModalYRegistrarPago(
      BuildContext context, String clienteId, double valor) {
    final TextEditingController valorController =
        TextEditingController(text: valor.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Guardar Pago'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('ID del Cliente: $clienteId'),
                TextField(
                  controller: valorController,
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () {
                double valorModificado =
                    double.tryParse(valorController.text) ?? valor;
                realizarPago(context, datosPago(valorModificado, clienteId));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> realizarPago(
      BuildContext context, Map<String, dynamic> datosPago) async {
    final url = Uri.parse('http://10.0.2.2:3000/api/pago-total');
    final headers = {"Content-Type": "application/json"};
    final body = json.encode(datosPago);

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i("Pago realizado con éxito");
        showCustomToastWithIcon(context, 'Pago realizado exitosamente');
        fetchClientes();
      } else {
        logger.e("Error al realizar el pago: ${response.body}");
      }
    } catch (e) {
      logger.e("Error al conectar al servidor: $e");
    }
  }

  Map<String, dynamic> datosPago(double valor, String cliente) {
    return {
      'valor': valor,
      'cliente': cliente,
    };
  }
}

