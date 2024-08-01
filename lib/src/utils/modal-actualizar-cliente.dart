// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:parqueadero/src/screen/clientes.dart';
import 'package:parqueadero/src/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActualizarClienteModal extends StatefulWidget {
  final String clienteId;
  final String nombreInicial;
  final String? apellido;
  final String? guarda;
  final String? telefono;
  final String? documento;
  final double valor;

  const ActualizarClienteModal({
    super.key,
    required this.clienteId,
    required this.nombreInicial,
    this.apellido,
    this.guarda,
    this.telefono,
    this.documento,
    required this.valor,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ActualizarClienteModalState createState() => _ActualizarClienteModalState();
}

class _ActualizarClienteModalState extends State<ActualizarClienteModal> {
  final _formKey = GlobalKey<FormState>();
  late String _nombre;
  late String? _apellido;
  late String? _guarda;
  late String? _telefono;
  late String? _documento;
  late double _valor;

  @override
  void initState() {
    super.initState();
    _nombre = widget.nombreInicial;
    _apellido = widget.apellido;
    _guarda = widget.guarda;
    _telefono = widget.telefono;
    _documento = widget.documento;
    _valor = widget.valor;
  }

  void showCustomToastWithIcon(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _actualizarCliente() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');

      if (token == null) {
        showCustomToastWithIcon(context, 'Error: Token no encontrado');
        return;
      }

      EasyLoading.show(status: 'Cargando total de pagos...');

      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        final response = await http.patch(
          Uri.parse(
              '${GlobalConfig.apiHost}:3000/api/cliente/${widget.clienteId}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        //   body:
        //       '{"nombre": "$_nombre"}, "apellido": "$_apellido", "guarda": "$_guarda", "telefono": "$_telefono", "documento": "$_documento", "valor": "$_valor"}',
        // );

        body: jsonEncode({
          'nombre': _nombre,
          'apellido': _apellido,
          'guarda': _guarda,
          'telefono': _telefono,
          'documento': _documento,
          'valor': _valor,
        }));

        if (response.statusCode == 200 || response.statusCode == 201) {
          logger.i('Cliente actualizado');
          Navigator.of(context).pop(true);
        } else {
          logger.e(
              'Error al actualizar el cliente: ${response.statusCode} - ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al actualizar el cliente')),
          );
        }
      }
    } catch (e) {
      logger.e('Error al actualizar el cliente: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar el cliente')),
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Actualizar Cliente'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _nombre,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un nombre';
                }
                return null;
              },
              onSaved: (value) {
                _nombre = value!;
              },
            ),
            TextFormField(
              initialValue: _valor.toString(),
              decoration: const InputDecoration(labelText: 'Valor'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un valor';
                }
                return null;
              },
              onSaved: (value) {
                _valor = double.parse(value!);
              },
            ),
            TextFormField(
              initialValue: _apellido,
              decoration: const InputDecoration(labelText: 'Apellido'),
              onSaved: (value) {
                _apellido = value!;
              },
            ),
            TextFormField(
              initialValue: _guarda,
              decoration: const InputDecoration(labelText: 'Guarda'),
              onSaved: (value) {
                _guarda = value!;
              },
            ),
            TextFormField(
              initialValue: _telefono,
              decoration: const InputDecoration(labelText: 'Telefono'),
              onSaved: (value) {
                _telefono = value!;
              },
            ),
            TextFormField(
              initialValue: _documento,
              decoration: const InputDecoration(labelText: 'Documento'),
              onSaved: (value) {
                _documento = value!;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _actualizarCliente,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
