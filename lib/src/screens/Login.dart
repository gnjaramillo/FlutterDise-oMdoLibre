
//login.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _loginUsuario() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://localhost:3030/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'correo': _correoController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final message = responseData['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        Navigator.pushNamed(context, '/home'); // Redirigir a la página principal
      } else {
        String errorMessage;
        try {
          final errorResponse = json.decode(response.body);
          errorMessage = errorResponse['error'] ?? 'Error desconocido';
        } catch (e) {
          errorMessage = 'Error al iniciar sesión';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.network(
                    "https://cdn-icons-png.flaticon.com/512/681/681494.png",
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Mercado Pago Colombia',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(78, 52, 46, 1)),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Iniciar Sesion para continuar',
                    style: TextStyle(fontSize: 16.0, color: Color.fromRGBO(109, 76, 65, 1)),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _correoController,
                    decoration: InputDecoration(
                      labelText: "Correo",
                      prefixIcon: const Icon(Icons.email_rounded, color: Color.fromRGBO(78, 52, 46, 1)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.brown[50],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su correo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Ingrese su contraseña",
                      prefixIcon: const Icon(Icons.lock_open_rounded, color: Color.fromARGB(255, 93, 64, 55)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.brown[50]),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su contraseña';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loginUsuario,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: const Color.fromARGB(255, 93, 64, 55),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Iniciar Sesion'),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/registroUsuarios');
                    },
                    child: const Text(
                      '¿No tienes cuenta? Registrate aqui',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


