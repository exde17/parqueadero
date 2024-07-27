
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';  // Para el formateo de fechas
import 'package:parqueadero/routes.dart';
import 'package:parqueadero/src/utils/bottom_navigation.dart.dart';
import 'package:parqueadero/src/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Paso 1: Definir la estructura de datos
class Alquiler {
  final String id; // Cambiado a String si el id es un UUID.
  final String nombreCliente;
  final String tipo;
  final int precio;

  Alquiler({
    required this.id,
    required this.nombreCliente,
    required this.tipo,
    required this.precio,
  });

  factory Alquiler.fromJson(Map<String, dynamic> json) {
    return Alquiler(
      id: json['id'], // No intentamos convertir id a int.
      nombreCliente: json['nombreCliente'],
      tipo: json['tipo'],
      precio: json['precio'] is int ? json['precio'] : int.parse(json['precio'].toString()),
    );
  }
}

class HistorialAlquiler {
  final DateTime fechaCreacion;
  final String valorPago;
  final String nombreCliente;

  HistorialAlquiler({
    required this.fechaCreacion,
    required this.valorPago,
    required this.nombreCliente,
  });

  factory HistorialAlquiler.fromJson(Map<String, dynamic> json) {
    return HistorialAlquiler(
      fechaCreacion: DateTime.parse(json['fechaEntrega']),
      valorPago: json['precio'] ?? '',
      nombreCliente: json['nombreCliente'] ?? '',
    );
  }
}

// Paso 2: Crear el widget principal
class AlquileresPage extends StatefulWidget {
  const AlquileresPage({super.key});

  @override
  _AlquileresPageState createState() => _AlquileresPageState();
}

class _AlquileresPageState extends State<AlquileresPage> {
  List<Alquiler> alquileres = [];
  List<HistorialAlquiler> historial = [];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.pushNamed(context, Routes.historial);
      }
      if (index == 1) {
        Navigator.pushNamed(context, Routes.alquiler);
      }
    });
  }

  Future<void> fetchAlquileres() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Token no encontrado');
    }

    EasyLoading.show(status: 'Cargando...');

    final response = await http.get(
      Uri.parse('${GlobalConfig.apiHost}:3000/api/alquiler'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      setState(() {
        alquileres =
            body.map((dynamic item) => Alquiler.fromJson(item)).toList();
      });
      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load alquileres');
    }
  }

  Future<List<HistorialAlquiler>> fetchHistorial() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Token no encontrado');
    }

    EasyLoading.show(status: 'Cargando...');

    final response = await http.get(
      Uri.parse('${GlobalConfig.apiHost}:3000/api/historial-alquiler'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      EasyLoading.dismiss();
      return body
          .map((dynamic item) => HistorialAlquiler.fromJson(item))
          .toList();
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load historial');
    }
  }

  Future<void> crearAlquiler(String nombreCliente) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Token no encontrado');
    }

    EasyLoading.show(status: 'Guardando...');

    final response = await http.post(
      Uri.parse('${GlobalConfig.apiHost}:3000/api/alquiler'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'nombreCliente': nombreCliente,
        'tipo': 'carreta',
        'precio': 5000,
      }),
    );

    if (response.statusCode == 201) {
      EasyLoading.dismiss();
      fetchAlquileres(); // Refrescar la lista de alquileres
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to create alquiler');
    }
  }

  Future<void> entregarAlquiler(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Token no encontrado');
    }

    // Mostrar cuadro de diálogo de confirmación
    bool? confirm = await showDialog<bool>(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text('¿Estás seguro de que deseas entregar este alquiler?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return; // Si el usuario cancela, no hacer nada
    }

    EasyLoading.show(status: 'Entregando...');

    final response = await http.get(
      Uri.parse(
          '${GlobalConfig.apiHost}:3000/api/historial-alquiler/historyAlquiler/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      EasyLoading.dismiss();
      fetchAlquileres();
      // Aquí puedes agregar cualquier acción adicional después de entregar el alquiler
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to entregar alquiler');
    }
  }

  void _showCrearAlquilerDialog() {
    final TextEditingController nombreController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Crear Alquiler'),
          content: TextField(
            controller: nombreController,
            decoration: const InputDecoration(labelText: 'Nombre del Cliente'),
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
                if (nombreController.text.isNotEmpty) {
                  crearAlquiler(nombreController.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchAlquileres();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alquileres'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return FutureBuilder<List<HistorialAlquiler>>(
                    future: fetchHistorial(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No hay historial disponible'));
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              child: ListTile(
                                title: Text(
                                  snapshot.data![index].nombreCliente,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 26, 47, 165), // Azul turquesa
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Fecha: ${DateFormat('dd/MM/yyyy').format(snapshot.data![index].fechaCreacion)}'),
                                    Text('Valor Pago: ${snapshot.data![index].valorPago}'),
                                  ],
                                ),
                                isThreeLine: true,
                              ),
                            );
                          },
                        );
                      }
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: alquileres.isEmpty
          ? const Center(child: Text('No hay alquileres disponibles'))
          : ListView.builder(
              itemCount: alquileres.length,
              itemBuilder: (context, index) {
                return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text(
                        alquileres[index].nombreCliente,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              Color.fromARGB(255, 7, 24, 124), // Azul turquesa
                        ),
                      ),
                      subtitle: Text(
                          '${alquileres[index].tipo} - \$${alquileres[index].precio}'),
                      trailing: ElevatedButton(
                        onPressed: () => entregarAlquiler(alquileres[index].id),
                        child: const Text('Entregar'),
                      ),
                    ));
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCrearAlquilerDialog,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: CustonBottomNavigation(
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: const AlquileresPage(),
      builder: EasyLoading.init(),
    ),
  );
}

