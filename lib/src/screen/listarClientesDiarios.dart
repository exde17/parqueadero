import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:parqueadero/src/utils/toast.dart';
import 'package:parqueadero/src/utils/config.dart';
import 'package:logger/logger.dart';

// Modelo de Cliente
class Cliente {
  final String id;
  final String nombre;
  final String? apellido;
  final bool isActive;

  Cliente({
    required this.id,
    required this.nombre,
    this.apellido,
    required this.isActive,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'],
      isActive: json['isActive'] ?? true,
    );
  }
}

class ClienteListWidget extends StatefulWidget {
  const ClienteListWidget({super.key});

  @override
  _ClienteListWidgetState createState() => _ClienteListWidgetState();
}

class _ClienteListWidgetState extends State<ClienteListWidget> {
  List<Cliente> clientes = [];
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    fetchClientes();
  }

  void showCustomToastWithIcon(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> fetchClientes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token == null) {
      // ignore: use_build_context_synchronously
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
        // ignore: use_build_context_synchronously
        showCustomToastWithIcon(context, 'Error al cargar los clientes');
      }
    } catch (e) {
      showCustomToastWithIcon(
          // ignore: use_build_context_synchronously
          context, 'Error de conexión. Inténtalo de nuevo.');
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lista de Clientes")),
      body: clientes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, index) {
                final cliente = clientes[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text('${cliente.nombre} ${cliente.apellido ?? ''}'),
                    subtitle: Text('ID: ${cliente.id}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      logger.i("Cliente seleccionado: ${cliente.nombre}");
                    },
                  ),
                );
              },
            ),
    );
  }
}
