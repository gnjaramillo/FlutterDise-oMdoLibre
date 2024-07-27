import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListaUsuarios extends StatelessWidget {
  const ListaUsuarios({super.key});

  Future<List<dynamic>> fetchUsuarios() async {
    final response = await http.get(Uri.parse('https://nodeproyectofluttermdolibre.onrender.com/api/usuarios'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load usuarios');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchUsuarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay usuarios disponibles'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final usuario = snapshot.data![index];
                return ListTile(
                  title: Text(usuario['nombre']),
                  subtitle: Text(usuario['cedula']),
                );
              },
            );
          }
        },
      ),
    );
  }
}
