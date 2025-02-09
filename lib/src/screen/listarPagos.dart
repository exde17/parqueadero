// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:parqueadero/src/screen/clientes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:parqueadero/src/utils/config.dart';

class PagosClienteWidget extends StatefulWidget {
  final String clientId;

  const PagosClienteWidget({super.key, required this.clientId});

  @override
  _PagosClienteWidgetState createState() => _PagosClienteWidgetState();
}

class _PagosClienteWidgetState extends State<PagosClienteWidget> {
  List<Pago> pagos = [];

  @override
  void initState() {
    super.initState();
    fetchPagos();
  }

  Future<void> fetchPagos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Token no encontrado')),
      );
      return;
    }

    EasyLoading.show(status: 'Cargando pagos...');

    final Uri url = Uri.parse('${GlobalConfig.apiHost}:3000/api/pago-total/${widget.clientId}');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // logger.d(response.body);
        List<dynamic> data = json.decode(response.body);
        setState(() {
          pagos = data.map((json) => Pago.fromJson(json)).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar los pagos')),
        );
      }
    } catch (e) {
      // logger.e(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión. Inténtalo de nuevo.')),
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> eliminarPago(String pagoId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Token no encontrado')),
      );
      return;
    }

    final Uri url = Uri.parse('${GlobalConfig.apiHost}:3000/api/pago-total/$pagoId');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          pagos.removeWhere((pago) => pago.id == pagoId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pago eliminado correctamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el pago')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión. Inténtalo de nuevo.')),
      );
    }
  }

  void confirmarEliminacion(String pagoId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar Eliminación"),
        content: const Text("¿Estás seguro de que deseas eliminar este pago?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              eliminarPago(pagoId);
            },
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );
  }

  void actualizarPago(String pagoId) {
    debugPrint("Actualizar pago con ID: $pagoId");
    // Aquí puedes abrir una pantalla para editar el pago
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pagos del Cliente")),
      body: pagos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pagos.length,
              itemBuilder: (context, index) {
                final pago = pagos[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.payment, color: Colors.white),
                    ),
                    title: Text(
                      "Pago de \$${pago.valor}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Fecha: ${pago.fecha} - Hora: ${pago.hora}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => actualizarPago(pago.id),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => confirmarEliminacion(pago.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class Pago {
  final String id;
  final String valor;
  final String fecha;
  final String hora;

  Pago({
    required this.id,
    required this.valor,
    required this.fecha,
    required this.hora,
  });

  factory Pago.fromJson(Map<String, dynamic> json) {
    return Pago(
      id: json['id'] ?? 'ID_DESCONOCIDO',
      valor: json['valor']?.toString() ?? '0',
      fecha: json['fecha'] ?? 'Fecha desconocida', // Asegurar que no se pierda
      hora: json['hora'] ?? 'Hora desconocida', // Asegurar que no se pierda
    );
  }
}


// class Pago {
//   final String id;
//   final String valor;
//   final String fecha;
//   final String hora;

//   Pago({
//     required this.id,
//     required this.valor,
//     required this.fecha,
//     required this.hora,
//   });

//   factory Pago.fromJson(Map<String, dynamic> json) {
//   DateTime createdAt = json['createdAt'] != null
//       ? DateTime.parse(json['createdAt'])
//       : DateTime.now(); // Valor por defecto si es null

//   return Pago(
//     id: json['id'] ?? 'ID_DESCONOCIDO', // Manejo de null en ID
//     valor: json['valor']?.toString() ?? '0', // Convertir a String y manejar null
//     fecha: "${createdAt.day}/${createdAt.month}/${createdAt.year}",
//     hora: "${createdAt.hour}:${createdAt.minute}:${createdAt.second}",
//   );
// }


