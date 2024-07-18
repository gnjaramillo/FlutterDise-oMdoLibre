
// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Registrarse extends StatefulWidget {
  const Registrarse({super.key});

  @override
  State<Registrarse> createState() => _RegistrarseState();
}

class _RegistrarseState extends State<Registrarse> {
  final _formKey = GlobalKey<FormState>();
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
                children: [Image.network("https://cdn-icons-png.flaticon.com/512/681/681494.png",
                width: 100,
                height: 100,
                ),
                const SizedBox(height: 10),
                const Text("REGISTRO DE USUARIO",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromRGBO(78, 52, 46, 1)),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: "Nombre Completo", 
                  prefixIcon: const Icon(Icons.person, color: Color.fromRGBO(78, 52, 46, 1)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.brown[50]),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: "Ingrese su cedula de ciudadania", 
                  prefixIcon: const Icon(Icons.perm_identity, color: Color.fromRGBO(78, 52, 46, 1)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.brown[50]),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: "Correo", 
                  prefixIcon: const Icon(Icons.email_rounded, color: Color.fromRGBO(78, 52, 46, 1)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.brown[50]),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: "Teléfono", 
                  prefixIcon: const Icon(Icons.phone, color: Color.fromRGBO(78, 52, 46, 1)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.brown[50]),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: "Dirección", 
                  prefixIcon: const Icon(Icons.location_on, color: Color.fromRGBO(78, 52, 46, 1)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.brown[50]),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Contraseña", 
                  prefixIcon: const Icon(Icons.lock_open_rounded, color: Color.fromRGBO(78, 52, 46, 1)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.brown[50]),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Confirmar contraseña", 
                  prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color.fromRGBO(78, 52, 46, 1)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.brown[50]),
                ),
                const SizedBox(height: 30.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: () {},
                   style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    backgroundColor: Colors.brown[700],
                    foregroundColor: Colors.white,
                   ),
                   child: const Text('Registrarse'),
                   ),
                ),
                const SizedBox(height: 20.0),
                TextButton(onPressed: () {
                      Navigator.pushNamed(context, '/inicioSesion');
                },
                 child: const Text(
                  '¿Ya tienes una cuenta? Inicia Sesion',
                  style: TextStyle(color: Color.fromRGBO(78, 52, 46, 1)),
                 ))
              ]
            )
          )
        )
      )
    ));
  }
}
