
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:parqueadero/routes.dart';
import 'package:parqueadero/src/utils/bar.dart';
import 'package:parqueadero/src/utils/bottom_navigation.dart.dart';
import 'package:parqueadero/src/utils/config.dart';
import 'package:parqueadero/src/utils/modal-detalle.dart';
import 'package:parqueadero/src/utils/toast.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  runApp(
    MaterialApp(
      home: const ClienteListPage(),
      builder: EasyLoading.init(),
    ),
  );
}

class ClienteListPage extends StatefulWidget {
  const ClienteListPage({super.key});

  @override
  _ClienteListPageState createState() => _ClienteListPageState();
}

class _ClienteListPageState extends State<ClienteListPage> {
  int _selectedIndex = 0;
  double totalPagos = 0.0;

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

  List<Cliente> clientes = [];

  @override
  void initState() {
    super.initState();
    fetchClientes();
    fetchTotalPagos();
  }

  Future<void> fetchClientes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token == null) {
      showCustomToastWithIcon(context, 'Error: Token no encontrado');
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
        showCustomToastWithIcon(context, 'Error al cargar los clientes');
      }
    } catch (e) {
      showCustomToastWithIcon(context, 'Error de conexión. Inténtalo de nuevo.');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> fetchTotalPagos() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('auth_token');

  if (token == null) {
    showCustomToastWithIcon(context, 'Error: Token no encontrado');
    return;
  }

  EasyLoading.show(status: 'Cargando total de pagos...');

  final Uri url = Uri.parse('${GlobalConfig.apiHost}:3000/api/pago-total/sumaPagos');
  final headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $token",
  };
  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = response.body;

      // Intentar decodificar el JSON
      try {
        final data = json.decode(responseBody);
        setState(() {
          totalPagos = double.parse(data['totalPagos'].replaceAll('.', '').replaceAll(',', '.')); // Manejar la conversión correcta
        });
      } catch (e) {
        // Si falla la decodificación de JSON, tratar la respuesta como un número entero
        setState(() {
          totalPagos = double.parse(responseBody.replaceAll('.', '').replaceAll(',', '.')); // Manejar la conversión correcta
        });
      }
    } else {
      // ignore: use_build_context_synchronously
      showCustomToastWithIcon(context, 'Error al cargar el total de pagos');
    }
  } catch (e) {
    logger.e('Error al cargar el total de pagos: $e');
    // ignore: use_build_context_synchronously
    showCustomToastWithIcon(context, 'Error de conexión. Inténtalo de nuevo.');
  } finally {
    EasyLoading.dismiss();
  }
}

  // Future<void> fetchTotalPagos() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String? token = prefs.getString('auth_token');

  //   if (token == null) {
  //     showCustomToastWithIcon(context, 'Error: Token no encontrado');
  //     return;
  //   }

  //   EasyLoading.show(status: 'Cargando total de pagos...');

  //   final Uri url = Uri.parse('${GlobalConfig.apiHost}:3000/api/pago-total/sumaPagos');
  //   final headers = {
  //     "Content-Type": "application/json",
  //     "Authorization": "Bearer $token",
  //   };
  //   try {
      
  //     final response = await http.get(url, headers: headers);
  //     // logger.i('fetchTotalPagos: ');
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final data = json.decode(response.body);
  //       setState(() {
  //         totalPagos = data['totalPagos'];
  //       });
  //     } else {
  //       showCustomToastWithIcon(context, 'Error al cargar el total de pagos');
  //     }
  //   } catch (e) {
  //     logger.e('fetchTotalPagos: $e');
  //     showCustomToastWithIcon(context, 'Error de conexión. Inténtalo de nuevo.');
  //   } finally {
  //     EasyLoading.dismiss();
  //   }
  // }

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token == null) {
      // ignore: use_build_context_synchronously
      showCustomToastWithIcon(context, 'Error: Token no encontrado');
      return;
    }

    EasyLoading.show(status: 'Guardando...');

    final Uri url = Uri.parse('${GlobalConfig.apiHost}:3000/api/cliente');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
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
        showToastMario(context, 'Cliente creado exitosamente');
        fetchClientes();
        fetchTotalPagos();  // Refrescar la suma de los pagos
      } else {
        var responseBody = response.body;
        var decodedResponse = jsonDecode(responseBody);
        String message = decodedResponse['message'];
        showCustomToastWithIcon(context, message);
      }
    } catch (e) {
      print('Error: $e'); // Imprime el error para depuración
      showCustomToastWithIcon(context, 'Error al crear el cliente. Inténtalo de nuevo.');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void showCustomToastWithIcon(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void verDetalle(Cliente cliente) async {
    try {
      EasyLoading.show(status: 'Cargando...');
      final datosPago = await obtenerDatosPago(cliente.id);
      EasyLoading.dismiss();
      mostrarModalPago(context, datosPago);
    } catch (e) {
      EasyLoading.dismiss();
      showCustomToastWithIcon(context, 'Error al cargar los datos del pago');
    }
  }

  void registrarPago(Cliente cliente, bool completo) {
    // Aquí iría el código para registrar el pago del cliente
  }

  void _navigateToHistorial(BuildContext context) {
    Navigator.pushNamed(context, Routes.historial);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBar.buildAppBar(context),
      appBar: CustomAppBar.buildAppBar(context, () => _navigateToHistorial(context)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Pagos: \$${totalPagos.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
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
                                  context, cliente.id, cliente.valor, cliente.nombre),
                        ),
                        IconButton(
                          icon: const Icon(Icons.info),
                          onPressed: () => verDetalle(cliente),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
      BuildContext context, String clienteId, double valor, String nombre) {
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
                Text('Nombre: $nombre'),
                TextField(
                  controller: valorController,
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token == null) {
      if (context.mounted) {
        showCustomToastWithIcon(context, 'Error: Token no encontrado');
      }
      return;
    }

    EasyLoading.show(status: 'Realizando pago...');

    final url = Uri.parse('${GlobalConfig.apiHost}:3000/api/pago-total');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
    final body = json.encode(datosPago);

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i('pilla: ${response.statusCode}');
        logger.i("Pago realizado con éxito");

        EasyLoading.showToast('Pago realizado exitosamente');
        fetchClientes();
        fetchTotalPagos(); // Refrescar la suma de los pagos
      } else {
        logger.e("Error al realizar el pago: ${response.body}");
        if (context.mounted) {
          showCustomToastWithIcon(
              context, 'Error al realizar el pago: ${response.body}');
        }
      }
    } catch (e) {
      logger.e("Error al conectar al servidor: $e");
      if (context.mounted) {
        showCustomToastWithIcon(context, 'Error al conectar al servidor: $e');
      }
    } finally {
      EasyLoading.dismiss();
    }
  }

  Map<String, dynamic> datosPago(double valor, String cliente) {
    return {
      'valor': valor,
      'cliente': cliente,
    };
  }

  //////////////////modal externo
  Future<void> mostrarInformacionPago(clienteId) async {
    try {
      EasyLoading.show(status: 'Cargando...');
      final datosPago = await obtenerDatosPago(clienteId);
      EasyLoading.dismiss();
      mostrarModalPago(context, datosPago);
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      // Manejo del error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener los datos del pago')),
      );
    }
  }
}

Future<Map<String, dynamic>> obtenerDatosPago(String clienteId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('auth_token');

  if (token == null) {
    throw Exception('Error: Token no encontrado');
  }

  final url =
      Uri.parse('${GlobalConfig.apiHost}:3000/api/pago-total/valores/$clienteId');
  final response = await http.get(url, headers: {
    "Content-Type": "application/json",
    "Authorization": "Bearer $token",
  });
  if (response.statusCode == 200 || response.statusCode == 201) {
    return json.decode(response.body);
  } else {
    throw Exception('Error al cargar los datos del pago');
  }
}

// Widget de modal para mostrar los datos
void mostrarModalPago(BuildContext context, Map<String, dynamic> datosPago) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Información de Pago'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Pago: ${datosPago['pago'] ? "Sí" : "No"}'),
              Text('Debe: ${datosPago['debe']}'),
              Text('Adelantado: ${datosPago['adelantado']}'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cerrar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
