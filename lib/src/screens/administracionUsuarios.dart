
// administracion_usuarios.dart


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdministracionUsuarios extends StatelessWidget {
  const AdministracionUsuarios({super.key});

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
        title: const Text('Administrar usuarios'),
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: Image.network(
                'https://cdn-icons-png.flaticon.com/512/1535/1535024.png', // Reemplaza esta URL con el vínculo de tu imagen
                width: 150,
                height: 150,
              ),
            ),
            const SizedBox(height: 20),
            _buildOption(context, Icons.search, 'Buscar usuario', () {}),
            _buildOption(context, Icons.person, 'Usuarios', () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return FractionallySizedBox(
                    heightFactor: 0.7,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.person, color: Colors.lightBlue),
                              SizedBox(width: 10),
                              Text(
                                'Usuarios',
                                style: const TextStyle(fontSize: 20, color: Colors.lightBlue),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: FutureBuilder<List<dynamic>>(
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
                                      subtitle: Text('${usuario['cedula']}\n${usuario['correo']}'),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.grey),
                                        onPressed: () {
                                          // Añade aquí la lógica para eliminar el usuario
                                        },
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
            _buildOption(context, Icons.request_page, 'Solicitudes', () {}),
            _buildOption(context, Icons.report, 'Informes', () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.lightBlue),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}
