import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parqueadero/src/utils/bar.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// Paso 1: Definir la estructura de datos
class RegistroHistorial {
  final String fechaCreacion;
  final String valorPago;
  final String nombreCliente;

  RegistroHistorial({
    required this.fechaCreacion,
    required this.valorPago,
    required this.nombreCliente,
  });

  factory RegistroHistorial.fromJson(Map<String, dynamic> json) {
    return RegistroHistorial(
      fechaCreacion: json['fechaCreacion'],
      valorPago: json['valorPago'],
      nombreCliente: json['nombreCliente'],
    );
  }
}

// Paso 2: Crear el widget Historial
class Historial extends StatefulWidget {
  const Historial({super.key});

  @override
  _HistorialState createState() => _HistorialState();
}

class _HistorialState extends State<Historial> {

Future<List<RegistroHistorial>> fetchHistorial() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('auth_token');

  if (token == null) {
    throw Exception('Token no encontrado');
  }

  final response = await http.get(
    Uri.parse('http://3.135.195.231:3000/api/historial'),
    // Incluir el token en los encabezados
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    List<RegistroHistorial> historial = body
        .map((dynamic item) => RegistroHistorial.fromJson(item))
        .toList();
    return historial;
  } else {
    throw Exception('Failed to load historial');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.buildAppBar(context),
      body: FutureBuilder<List<RegistroHistorial>>(
        future: fetchHistorial(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<RegistroHistorial>? data = snapshot.data;
            return ListView.builder(
                itemCount: data?.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data![index].nombreCliente),
                    subtitle: Text('${data[index].fechaCreacion} - ${data[index].valorPago}'),
                  );
                });
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // Por defecto, muestra un loading spinner
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}