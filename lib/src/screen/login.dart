// import 'package:ingresos_egresos/rutes.dart';
// import 'package:ingresos_egresos/src/screens/registro.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:parqueadero/routes.dart';
// import 'dart:convert';

// import 'package:parqueadero/src/screen/register.dart';
// import 'package:parqueadero/src/utils/config.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Login extends StatefulWidget {
//   const Login({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _LoginState createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//   bool _mostrarPassword =
//       false; // Estado para controlar la visibilidad de la contraseña
//   // bool _isLoading = false; // Estado para el indicador de progreso
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   void dispose() {
//     // Limpia los controladores cuando el Widget se desmonte
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Barra superior /////////////////////////////////////////////////
//       appBar: AppBar(
//         automaticallyImplyLeading:
//             false, // Esto deshabilita el botón de regreso automático
//         // el resto de tu AppBar aquí
//         title: Row(
//           mainAxisAlignment:
//               MainAxisAlignment.center, // Centra los elementos dentro de la Row
//           children: [
//             // Aumenta el tamaño del texto del título
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 'Parqueadero', // El título
//                 style: TextStyle(
//                   fontSize: MediaQuery.of(context).size.width * 0.1,
//                   fontWeight: FontWeight.bold, // Hace el texto más grueso
//                   color: const Color.fromRGBO(158, 158, 158,
//                       1), // Color gris oscuro // Ajusta el tamaño del texto según necesites
//                 ),
//               ),
//             ),
//             SizedBox(
//                 width: MediaQuery.of(context).size.width *
//                     0.04), // Espacio entre el título y la imagen
//             // Añade tu imagen
//             // Image.asset(
//             //   'lib/assets/logoHumanSave_transparent.png', // Asegúrate de que la ruta de tu imagen sea correcta
//             //   width: MediaQuery.of(context).size.width * 0.1,
//             //   height: MediaQuery.of(context).size.height * 0.1,
//             // ),
//           ],
//         ),
//         centerTitle:
//             true, // Centra el Row, pero no sus contenidos internos individualmente
//       ),

//       // Cuerpo de la pantalla /////////////////////////////////////////////
//       body: Center(
//           child: Container(
//               height:
//                   MediaQuery.of(context).size.height * 0.8, // Altura del cuerpo
//               width:
//                   MediaQuery.of(context).size.width * 0.94, // Ancho del cuerpo
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     Colors.grey[200] as Color, // Color de inicio del gradiente
//                     Colors.grey[900] as Color, // Color de fin del gradiente
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white, // Color de fondo del Container interno
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Center(
//                     child: Column(
//                   // mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(
//                           top: MediaQuery.of(context).size.height *
//                               0.08 // Añade un poco de espacio arriba del título
//                           ),
//                       child: Text(
//                         'Welcome Back', // El título
//                         style: TextStyle(
//                           fontSize: MediaQuery.of(context).size.width * 0.08,
//                           fontWeight:
//                               FontWeight.bold, // Hace el texto más grueso
//                           color: const Color.fromRGBO(26, 20, 20,
//                               1), // Color gris oscuro // Ajusta el tamaño del texto según necesites
//                         ),
//                       ),
//                     ),

//                     SizedBox(height: MediaQuery.of(context).size.height * 0.08),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: MediaQuery.of(context).size.width * 0.05,
//                       ),
//                       child: TextField(
//                         controller: _emailController,
//                         keyboardType: TextInputType.emailAddress,
//                         decoration: const InputDecoration(
//                           labelText: 'Email',
//                           labelStyle: TextStyle(
//                             color: Color(0xFFBEBCBC),
//                             fontWeight: FontWeight.w700,
//                           ),
//                           suffixIcon: Icon(
//                             Icons.person, // Ícono de usuario
//                             color: Color(0xFFBEBCBC),
//                           ),
//                         ),
//                         onChanged: (value) => {},
//                       ),
//                     ),
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.02),

//                     // Contraseña///////////////////////////////////////////////
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: MediaQuery.of(context).size.width * 0.05,
//                       ),
//                       child: TextField(
//                           controller: _passwordController,
//                           keyboardType: TextInputType.visiblePassword,
//                           obscureText:
//                               !_mostrarPassword, // Usa el estado para controlar si se muestra la contraseña
//                           decoration: InputDecoration(
//                             labelText: 'Password',
//                             labelStyle: const TextStyle(
//                               color: Color(0xFFBEBCBC),
//                               fontWeight: FontWeight.w700,
//                             ),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 // Cambia el ícono dependiendo si se muestra o no la contraseña
//                                 _mostrarPassword
//                                     ? Icons.visibility
//                                     : Icons.visibility_off,
//                                 color: const Color(0xFFBEBCBC),
//                               ),
//                               onPressed: () {
//                                 // Cambia el estado para mostrar u ocultar la contraseña
//                                 setState(() {
//                                   _mostrarPassword = !_mostrarPassword;
//                                 });
//                               },
//                             ),
//                           ),
//                           onChanged: (value) => {}),
//                     ),
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.02),

//                     // Botón de login///////////////////////////////////////////////
//                     ElevatedButton(
//                       onPressed: () {
//                         // Usar los controladores para obtener el email y la contraseña
//                         login(_emailController.text, _passwordController.text);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         minimumSize: const Size(190, 50),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         backgroundColor: Colors.blue[900],
//                       ),
//                       child: Text(
//                         'Sing In',
//                         style: TextStyle(
//                           fontSize: MediaQuery.of(context).size.height * 0.023,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: MediaQuery.of(context).size.width * 0.01,
//                     ),

//                     // Texto Registrarme/////////////////////////////////////////////7
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>
//                                   const Register()), // Navega a la pantalla de registro
//                         );
//                       },
//                       child: RichText(
//                         text: const TextSpan(
//                           children: [
//                             TextSpan(
//                               text: '¿You do not have an account? ',
//                               style: TextStyle(
//                                 color: Colors.black, // Texto en negro
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                             TextSpan(
//                               text: 'Sign up',
//                               style: TextStyle(
//                                 color: Colors.blue, // Texto en azul
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     Text(
//                       'Or sign in with',
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: MediaQuery.of(context).size.width * 0.065,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     SizedBox(height: MediaQuery.of(context).size.height * 0.05),

//                     ////////////botones redes sociales/////////////////////////
//                     ElevatedButton(
//                       onPressed: () {
//                         // Lógica para iniciar sesión con Google
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white, // Color del botón
//                         minimumSize: const Size(300, 50),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize
//                             .min, // Para que el Row tome el tamaño mínimo necesario
//                         children: [
//                           const Icon(
//                             FontAwesomeIcons.google, // Ícono de usuario
//                             color: Colors.black,
//                           ),
//                           SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.08),
//                           const Text(
//                             'Continue with Google',
//                             style: TextStyle(
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//                     ElevatedButton(
//                       onPressed: () {
//                         // Lógica para iniciar sesión con Google
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white, // Color del botón
//                         minimumSize: const Size(300, 50),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize
//                             .min, // Para que el Row tome el tamaño mínimo necesario
//                         children: [
//                           const Icon(
//                             FontAwesomeIcons.facebookF, // Ícono de usuario
//                             color: Colors.black,
//                           ),
//                           SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.08),
//                           const Text(
//                             'Continue with Facebook',
//                             style: TextStyle(
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 )),
//               ))),
//     );

//     // Widget buildBodyContent() {}
//   }

//   Future<void> login(String email, String password) async {
//     setState(() {
//       // _isLoading = true; // Inicia el indicador de progreso
//     });

//     // final Uri url = Uri.parse(
//     //     'https://devempowerapp.gatewayit.co/empowerapp/api/auth/login');
//     final Uri url = Uri.parse('${GlobalConfig.apiHost}:3000/api/auth/login');
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'email': email,
//         'password': password,
//       }),
//     );

//     if (mounted) {
//       setState(() {
//         // _isLoading = false; // Detiene el indicador de progreso
//       });
//       // Verifica si el widget aún está montado
//       if (response.statusCode == 200 || response.statusCode == 201) {
        
//         final responseData = json.decode(response.body);
//         json.decode(response.body);
//         final String token = responseData['token'];

//         // Guardar el token usando SharedPreferences
//         final SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('auth_token', token);

//         // ignore: use_build_context_synchronously
//         Navigator.pushReplacementNamed(context, Routes.cliente);
//       } else {
//         // Error al hacer login
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error al hacer login: ${response.body}')),
//         );
//       }
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:parqueadero/routes.dart';
import 'dart:convert';

import 'package:parqueadero/src/screen/register.dart';
import 'package:parqueadero/src/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _mostrarPassword = false; // Estado para controlar la visibilidad de la contraseña
  bool _isLoading = false; // Estado para el indicador de progreso
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Limpia los controladores cuando el Widget se desmonte
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior /////////////////////////////////////////////////
      appBar: AppBar(
        automaticallyImplyLeading: false, // Esto deshabilita el botón de regreso automático
        // el resto de tu AppBar aquí
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centra los elementos dentro de la Row
          children: [
            // Aumenta el tamaño del texto del título
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Parqueadero', // El título
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.1,
                  fontWeight: FontWeight.bold, // Hace el texto más grueso
                  color: const Color.fromRGBO(158, 158, 158, 1), // Color gris oscuro // Ajusta el tamaño del texto según necesites
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.04), // Espacio entre el título y la imagen
            // Añade tu imagen
            // Image.asset(
            //   'lib/assets/logoHumanSave_transparent.png', // Asegúrate de que la ruta de tu imagen sea correcta
            //   width: MediaQuery.of(context).size.width * 0.1,
            //   height: MediaQuery.of(context).size.height * 0.1,
            // ),
          ],
        ),
        centerTitle: true, // Centra el Row, pero no sus contenidos internos individualmente
      ),

      // Cuerpo de la pantalla /////////////////////////////////////////////
      body: Center(
        child: Stack(
          children: [
            // El contenido principal de la pantalla
            Container(
              height: MediaQuery.of(context).size.height * 0.8, // Altura del cuerpo
              width: MediaQuery.of(context).size.width * 0.94, // Ancho del cuerpo
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey[200] as Color, // Color de inicio del gradiente
                    Colors.grey[900] as Color, // Color de fin del gradiente
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Color de fondo del Container interno
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.08 // Añade un poco de espacio arriba del título
                        ),
                        child: Text(
                          'Welcome Back', // El título
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.08,
                            fontWeight: FontWeight.bold, // Hace el texto más grueso
                            color: const Color.fromRGBO(26, 20, 20, 1), // Color gris oscuro // Ajusta el tamaño del texto según necesites
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05,
                        ),
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: Color(0xFFBEBCBC),
                              fontWeight: FontWeight.w700,
                            ),
                            suffixIcon: Icon(
                              Icons.person, // Ícono de usuario
                              color: Color(0xFFBEBCBC),
                            ),
                          ),
                          onChanged: (value) => {},
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                      // Contraseña///////////////////////////////////////////////
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05,
                        ),
                        child: TextField(
                          controller: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !_mostrarPassword, // Usa el estado para controlar si se muestra la contraseña
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                              color: Color(0xFFBEBCBC),
                              fontWeight: FontWeight.w700,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Cambia el ícono dependiendo si se muestra o no la contraseña
                                _mostrarPassword ? Icons.visibility : Icons.visibility_off,
                                color: const Color(0xFFBEBCBC),
                              ),
                              onPressed: () {
                                // Cambia el estado para mostrar u ocultar la contraseña
                                setState(() {
                                  _mostrarPassword = !_mostrarPassword;
                                });
                              },
                            ),
                          ),
                          onChanged: (value) => {},
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                      // Botón de login///////////////////////////////////////////////
                      ElevatedButton(
                        onPressed: () {
                          // Usar los controladores para obtener el email y la contraseña
                          login(_emailController.text, _passwordController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(190, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: Colors.blue[900],
                        ),
                        child: Text(
                          'Sing In',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.023,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.01,
                      ),
                      // Texto Registrarme/////////////////////////////////////////////7
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Register()), // Navega a la pantalla de registro
                          );
                        },
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: '¿You do not have an account? ',
                                style: TextStyle(
                                  color: Colors.black, // Texto en negro
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: 'Sign up',
                                style: TextStyle(
                                  color: Colors.blue, // Texto en azul
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        'Or sign in with',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: MediaQuery.of(context).size.width * 0.065,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      ////////////botones redes sociales/////////////////////////
                      ElevatedButton(
                        onPressed: () {
                          // Lógica para iniciar sesión con Google
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Color del botón
                          minimumSize: const Size(300, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Para que el Row tome el tamaño mínimo necesario
                          children: [
                            const Icon(
                              FontAwesomeIcons.google, // Ícono de usuario
                              color: Colors.black,
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.08),
                            const Text(
                              'Continue with Google',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                      ElevatedButton(
                        onPressed: () {
                          // Lógica para iniciar sesión con Facebook
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Color del botón
                          minimumSize: const Size(300, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Para que el Row tome el tamaño mínimo necesario
                          children: [
                            const Icon(
                              FontAwesomeIcons.facebookF, // Ícono de usuario
                              color: Colors.black,
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.08),
                            const Text(
                              'Continue with Facebook',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            // Barra de progreso superpuesta
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> login(String email, String password) async {
    setState(() {
      _isLoading = true; // Inicia el indicador de progreso
    });

    final Uri url = Uri.parse('${GlobalConfig.apiHost}:3000/api/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (mounted) {
      setState(() {
        _isLoading = false; // Detiene el indicador de progreso
      });
      // Verifica si el widget aún está montado
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final String token = responseData['token'];

        // Guardar el token usando SharedPreferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, Routes.cliente);
      } else {
        // Error al hacer login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al hacer login: ${response.body}')),
        );
      }
    }
  }
}

