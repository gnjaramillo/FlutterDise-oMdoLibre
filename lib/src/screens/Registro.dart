// registro.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Registrarse extends StatefulWidget {
  const Registrarse({super.key});

  @override
  State<Registrarse> createState() => _RegistrarseState();
}

class _RegistrarseState extends State<Registrarse> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _registrarUsuario() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('https://nodeproyectofluttermdolibre.onrender.com/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nombre': _nombreController.text,
          'cedula': _cedulaController.text,
          'correo': _correoController.text,
          'telefono': _telefonoController.text,
          'direccion': _direccionController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Registro exitoso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso')),
        );
        // Limpiar el formulario
        _limpiarFormulario();
        // Navegar a la página de inicio de sesión después de limpiar el formulario
        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.pushNamed(context, '/inicioSesion');
        });
      } else {
        // Error en el registro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar el usuario: ${response.body}')),
        );
      }
    }
  }

  void _limpiarFormulario() {
    _nombreController.clear();
    _cedulaController.clear();
    _correoController.clear();
    _telefonoController.clear();
    _direccionController.clear();
    _passwordController.clear();
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
                  const SizedBox(height: 10),
                  const Text(
                    "REGISTRO DE USUARIO",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(78, 52, 46, 1),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      labelText: "Nombre Completo",
                      prefixIcon: const Icon(Icons.person, color: Color.fromRGBO(78, 52, 46, 1)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.brown[50],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su nombre completo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _cedulaController,
                    decoration: InputDecoration(
                      labelText: "Ingrese su cédula de ciudadanía",
                      prefixIcon: const Icon(Icons.perm_identity, color: Color.fromRGBO(78, 52, 46, 1)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.brown[50],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su cédula';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
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
                        return 'Por favor ingrese su correo electrónico';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _telefonoController,
                    decoration: InputDecoration(
                      labelText: "Teléfono",
                      prefixIcon: const Icon(Icons.phone, color: Color.fromRGBO(78, 52, 46, 1)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.brown[50],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su número de teléfono';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _direccionController,
                    decoration: InputDecoration(
                      labelText: "Dirección",
                      prefixIcon: const Icon(Icons.location_on, color: Color.fromRGBO(78, 52, 46, 1)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.brown[50],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su dirección';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock_open_rounded, color: Color.fromRGBO(78, 52, 46, 1)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.brown[50],
                    ),
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
                      onPressed: _registrarUsuario,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        backgroundColor: Colors.brown[700],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Registrarse'),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/inicioSesion');
                    },
                    child: const Text(
                      '¿Ya tienes una cuenta? Inicia Sesión',
                      style: TextStyle(color: Color.fromRGBO(78, 52, 46, 1)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
