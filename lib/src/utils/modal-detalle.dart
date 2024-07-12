// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Función para obtener los datos del pago
Future<Map<String, dynamic>> obtenerDatosPago(String clienteId) async {
  final url = Uri.parse('http://10.0.2.2:3000/api/pago-total/valores/$clienteId');
  final response = await http.get(url);
  if (response.statusCode == 200) {
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