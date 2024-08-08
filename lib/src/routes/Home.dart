// ignore_for_file: file_names


// home.dart





/* import 'package:flutter/material.dart';
import 'package:mercado_pago_col/src/screens/paginaInicio.dart';
import 'package:mercado_pago_col/src/screens/Login.dart';
import 'package:mercado_pago_col/src/screens/Registro.dart';
import 'package:mercado_pago_col/src/screens/administracionUsuarios.dart';
import 'package:mercado_pago_col/src/screens/administracionProductos.dart'; 

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PaginaInicio(),
      routes: {
        '/inicioSesion': (context) => const Login(),
        '/registroUsuarios': (context) => const Registrarse(),
        '/administracionUsuarios': (context) => const AdministracionUsuarios(),
        '/administracionProductos': (context) => const AdministracionProductos(), 
      },
    );
  }
}
 */


// home.dart

import 'package:flutter/material.dart';
import 'package:mercado_pago_col/src/screens/paginaInicio.dart';
import 'package:mercado_pago_col/src/screens/Login.dart';
import 'package:mercado_pago_col/src/screens/Registro.dart';
import 'package:mercado_pago_col/src/screens/administracionUsuarios.dart';
import 'package:mercado_pago_col/src/screens/administracionProductos.dart';
import 'package:mercado_pago_col/src/screens/administracionCategorias.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PaginaInicio(),
      routes: {
        '/inicioSesion': (context) => const Login(),
        '/registroUsuarios': (context) => const Registrarse(),
        '/administracionUsuarios': (context) => const AdministracionUsuarios(),
        '/administracionProductos': (context) => const AdministracionProductos(), // Agrega la nueva ruta
        '/administracionCategorias': (context) => const AdministracionCategorias(), // Agrega la nueva ruta
      },
    );
  }
}
