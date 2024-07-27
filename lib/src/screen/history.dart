
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:http/http.dart' as http;
// import 'package:parqueadero/src/utils/bar.dart';
// import 'package:parqueadero/src/utils/config.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// // Paso 1: Definir la estructura de datos
// class RegistroHistorial {
//   final String fechaCreacion;
//   final String valorPago;
//   final String nombreCliente;

//   RegistroHistorial({
//     required this.fechaCreacion,
//     required this.valorPago,
//     required this.nombreCliente,
//   });

//   factory RegistroHistorial.fromJson(Map<String, dynamic> json) {
//     return RegistroHistorial(
//       fechaCreacion: json['fechaCreacion'],
//       valorPago: json['valorPago'],
//       nombreCliente: json['nombreCliente'],
//     );
//   }
// }

// // Paso 2: Crear el widget Historial
// class Historial extends StatefulWidget {
//   const Historial({super.key});

//   @override
//   _HistorialState createState() => _HistorialState();
// }

// class _HistorialState extends State<Historial> {
//   Future<List<RegistroHistorial>> fetchHistorial() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? token = prefs.getString('auth_token');

//     if (token == null) {
//       throw Exception('Token no encontrado');
//     }

//     EasyLoading.show(status: 'Cargando...');

//     final response = await http.get(
//       Uri.parse('${GlobalConfig.apiHost}:3000/api/historial'),
//       // Incluir el token en los encabezados
//       headers: {
//         'Authorization': 'Bearer $token',
//       },
//     );

//     if (response.statusCode == 200) {
//       List<dynamic> body = json.decode(response.body);
//       List<RegistroHistorial> historial = body
//           .map((dynamic item) => RegistroHistorial.fromJson(item))
//           .toList();
//       EasyLoading.dismiss();
//       return historial;
//     } else {
//       EasyLoading.dismiss();
//       throw Exception('Failed to load historial');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar.buildAppBar(context),
//       body: FutureBuilder<List<RegistroHistorial>>(
//         future: fetchHistorial(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             // Mostrar indicador de carga mientras se espera
//             return Container();
//           } else if (snapshot.hasError) {
//             return Center(child: Text("${snapshot.error}"));
//           } else if (snapshot.hasData) {
//             List<RegistroHistorial>? data = snapshot.data;
//             return ListView.builder(
//               itemCount: data?.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(data![index].nombreCliente),
//                   subtitle: Text('${data[index].fechaCreacion} - ${data[index].valorPago}'),
//                 );
//               },
//             );
//           }
//           return Container();
//         },
//       ),
//     );
//   }
// }

// void main() {
//   runApp(
//     MaterialApp(
//       home: const Historial(),
//       builder: EasyLoading.init(),
//     ),
//   );
// }

// ignore_for_file: use_build_context_synchronously

//----------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:http/http.dart' as http;
// import 'package:parqueadero/src/screen/clientes.dart';
// import 'package:parqueadero/src/utils/bar.dart';
// import 'package:parqueadero/src/utils/config.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// // Paso 1: Definir la estructura de datos
// class RegistroHistorial {
//   final String fechaCreacion;
//   final String valorPago;
//   final String nombreCliente;

//   RegistroHistorial({
//     required this.fechaCreacion,
//     required this.valorPago,
//     required this.nombreCliente,
//   });

//   factory RegistroHistorial.fromJson(Map<String, dynamic> json) {
//     return RegistroHistorial(
//       fechaCreacion: json['fechaCreacion'],
//       valorPago: json['valorPago'],
//       nombreCliente: json['nombreCliente'],
//     );
//   }
// }

// // Paso 2: Crear el widget Historial
// class Historial extends StatefulWidget {
//   const Historial({super.key});

//   @override
//   _HistorialState createState() => _HistorialState();
// }

// class _HistorialState extends State<Historial> {
//   void showCustomToastWithIcon(BuildContext context, String message) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text(message)),
//   );
// }
//   String tipoFiltro = 'dia';
//   DateTime selectedDate = DateTime.now();
//   List<RegistroHistorial> historial = [];

//   Future<void> fetchHistorial(String tipoFiltro, DateTime fecha) async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   final String? token = prefs.getString('auth_token');

//   if (token == null) {
//     throw Exception('Token no encontrado');
//   }

//   EasyLoading.show(status: 'Cargando...');

//   final Uri url = Uri.parse('${GlobalConfig.apiHost}:3000/api/historial/fecha');
//   final headers = {
//     'Authorization': 'Bearer $token',
//     'Content-Type': 'application/json',
//   };
//   final body = json.encode({
//     'fecha': fecha.toIso8601String(),
//     'tipoFiltro': tipoFiltro,
//   });

//   try {
//     final response = await http.post(url, headers: headers, body: body);

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       logger.i(response.body);
//       try {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           historial = data.map((dynamic item) => RegistroHistorial.fromJson(item)).toList();
//         });
//       } catch (e) {
//         showCustomToastWithIcon(context, 'Error al decodificar la respuesta del servidor: $e');
//       }
//     } else {
//       showCustomToastWithIcon(context, 'Error al cargar el historial');
//     }
//   } catch (e) {
//     print('Error al cargar el historial: $e');
//     showCustomToastWithIcon(context, 'Error de conexión. Inténtalo de nuevo.');
//   } finally {
//     EasyLoading.dismiss();
//   }
// }


//   @override
//   void initState() {
//     super.initState();
//     fetchHistorial(tipoFiltro, selectedDate);
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }

//   void _applyFilter() {
//     fetchHistorial(tipoFiltro, selectedDate);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar.buildAppBar(context),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: DropdownButton<String>(
//                         value: tipoFiltro,
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             tipoFiltro = newValue!;
//                           });
//                         },
//                         items: <String>['dia', 'mes', 'anio']
//                             .map<DropdownMenuItem<String>>((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(value),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                     // ignore: prefer_const_constructors
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () => _selectDate(context),
//                         child: Text("${selectedDate.toLocal()}".split(' ')[0]),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: _applyFilter,
//                   child: const Text('Aplicar Filtro'),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: historial.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(historial[index].nombreCliente),
//                   subtitle: Text('${historial[index].fechaCreacion} - ${historial[index].valorPago}'),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// void main() {
//   runApp(
//     MaterialApp(
//       home: const Historial(),
//       builder: EasyLoading.init(),
//     ),
//   );
// }

//----------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:parqueadero/src/utils/bar.dart';
import 'package:parqueadero/src/utils/config.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

// Logger instance
var logger = Logger();

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
  String tipoFiltro = 'dia';
  DateTime selectedDate = DateTime.now();
  List<RegistroHistorial> historial = [];
  double totalFiltrado = 0.0;

  void showCustomToastWithIcon(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> fetchHistorial(String tipoFiltro, DateTime fecha) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Token no encontrado');
    }

    EasyLoading.show(status: 'Cargando...');

    final Uri url = Uri.parse('${GlobalConfig.apiHost}:3000/api/historial/fecha');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = json.encode({
      'fecha': fecha.toIso8601String(),
      'tipoFiltro': tipoFiltro,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.body);
        final data = json.decode(response.body);
        List<dynamic> rawData = data['data'];
        double total = double.parse(data['total'].replaceAll('.', '').replaceAll(',', '.'));

        setState(() {
          historial = rawData.map((dynamic item) => RegistroHistorial.fromJson(item)).toList();
          totalFiltrado = total;
        });
      } else {
        showCustomToastWithIcon(context, 'Error al cargar el historial');
      }
    } catch (e) {
      logger.e('Error al cargar el historial: $e');
      //print('Error al cargar el historial: $e');
      showCustomToastWithIcon(context, 'Error de conexión. Inténtalo de nuevo.');
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchHistorial(tipoFiltro, selectedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _applyFilter() {
    fetchHistorial(tipoFiltro, selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.buildAppBar(context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        value: tipoFiltro,
                        onChanged: (String? newValue) {
                          setState(() {
                            tipoFiltro = newValue!;
                          });
                        },
                        items: <String>['dia', 'mes', 'anio']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    // ignore: prefer_const_constructors
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: Text("${selectedDate.toLocal()}".split(' ')[0]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _applyFilter,
                  child: const Text('Aplicar Filtro'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: historial.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(historial[index].nombreCliente),
                  subtitle: Text('${historial[index].fechaCreacion} - ${historial[index].valorPago}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total: \$${totalFiltrado.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: const Historial(),
      builder: EasyLoading.init(),
    ),
  );
}
