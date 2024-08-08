/* // ignore: file_names
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




 */



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

  Future<void> deleteUsuario(String id) async {
    final response = await http.delete(Uri.parse('https://nodeproyectofluttermdolibre.onrender.com/api/usuarios/$id'));

    if (response.statusCode == 200) {
      // Notify success and refresh the list
    } else {
      // Notify error
    }
  }

  Future<void> updateUsuario(String id, Map<String, String> updatedData) async {
    final response = await http.put(
      Uri.parse('https://nodeproyectofluttermdolibre.onrender.com/api/usuarios/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 200) {
      // Notify success and refresh the list
    } else {
      // Notify error
    }
  }

  void _showDeleteConfirmDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás seguro de que quieres eliminar este usuario?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () async {
                try {
                  await deleteUsuario(userId);
                  Navigator.of(context).pop();
                  // Refresh the list
                } catch (e) {
                  // Handle error
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditUserDialog(BuildContext context, String userId, Map<String, dynamic> user) {
    final nombreController = TextEditingController(text: user['nombre']);
    final correoController = TextEditingController(text: user['correo']);
    final telefonoController = TextEditingController(text: user['telefono']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Usuario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: correoController,
                decoration: const InputDecoration(labelText: 'Correo'),
              ),
              TextField(
                controller: telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () async {
                try {
                  final updatedData = {
                    'nombre': nombreController.text,
                    'correo': correoController.text,
                    'telefono': telefonoController.text,
                  };
                  await updateUsuario(userId, updatedData);
                  Navigator.of(context).pop();
                  // Refresh the list
                } catch (e) {
                  // Handle error
                }
              },
            ),
          ],
        );
      },
    );
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showEditUserDialog(context, usuario['_id'], usuario);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteConfirmDialog(context, usuario['_id']);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
