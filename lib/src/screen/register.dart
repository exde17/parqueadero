import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:parqueadero/routes.dart';
import 'package:parqueadero/src/utils/config.dart';
import 'package:parqueadero/src/utils/toast.dart';

TextEditingController _passwordController = TextEditingController();
TextEditingController _emailController = TextEditingController();
TextEditingController _nameController = TextEditingController();
TextEditingController _lastNameController = TextEditingController();

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'HumanSave',
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 10),
            Image.asset(
              'lib/assets/logoHumanSave_transparent.png',
              width: 50,
              height: 50,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(19.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Acción del botón
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Escuchar"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Textt(
              labelText: 'Nombre',
              controller: _nameController,
              onChanged: (value) => {},
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            Textt(
              labelText: 'Apellido',
              controller: _lastNameController,
              onChanged: (value) => {},
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            Textt(
              labelText: 'Email',
              controller: _emailController,
              onChanged: (value) => {},
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            Textt(
              labelText: 'Contraseña',
              controller: _passwordController,
              onChanged: (value) => {},
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.2,
            ),
            ElevatedButton(
              onPressed: () => {
                register(
                  _nameController.text,
                  _lastNameController.text,
                  _emailController.text,
                  _passwordController.text,
                  context,
                )
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Registrarse',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.03,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(
                        FontAwesomeIcons.facebookF,
                        color: Colors.white,
                        size: 40,
                      ),
                      label: const Text(''),
                      onPressed: () {
                        // Lógica para iniciar sesión con Facebook
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 7, 67, 187),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(11),
                      ),
                    ),
                    const SizedBox(width: 40),
                    ElevatedButton.icon(
                      icon: const Icon(
                        FontAwesomeIcons.google,
                        color: Colors.white,
                        size: 35,
                      ),
                      label: const Text(''),
                      onPressed: () {
                        // Lógica para iniciar sesión con Google
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 211, 26, 9),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(13),
                      ),
                    ),
                    const SizedBox(width: 40),
                    ElevatedButton.icon(
                      icon: const Icon(
                        FontAwesomeIcons.linkedin,
                        color: Colors.white,
                        size: 32,
                      ),
                      label: const Text(''),
                      onPressed: () {
                        // Lógica para iniciar sesión con LinkedIn
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 2, 141, 215),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class Textt extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final void Function(String) onChanged;
  const Textt({
    super.key,
    required this.labelText,
    required this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Color(0xFFBEBCBC),
            fontWeight: FontWeight.w700,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

Future<void> register(String name, String apellido, String email,
    String password, BuildContext context) async {
  final Uri url = Uri.parse('${GlobalConfig.apiHost}:3000/api/auth/register');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'firstName': name,
        'lastName': apellido,
        'password': password,
        'email': email,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, Routes.login);
    } else {
      var responseBody = response.body;
      var decodedResponse = jsonDecode(responseBody);
      String message = decodedResponse['message'][0];
      // ignore: use_build_context_synchronously
      showToastMario(context, message);
    }
  } catch (e) {
    // Muestra un mensaje de error en caso de fallo
    // ignore: use_build_context_synchronously
    showToastMario(context, 'Error al registrar. Inténtalo de nuevo.');
  }
}
