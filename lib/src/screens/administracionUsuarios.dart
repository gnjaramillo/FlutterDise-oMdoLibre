

// administracionUsuarios.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdministracionUsuarios extends StatefulWidget {
  const AdministracionUsuarios({super.key});

  @override
  _AdministracionUsuariosState createState() => _AdministracionUsuariosState();
}

class _AdministracionUsuariosState extends State<AdministracionUsuarios> {
  Future<List<dynamic>>? _usuariosFuture;

  @override
  void initState() {
    super.initState();
    _usuariosFuture = fetchUsuarios();
  }

  Future<List<dynamic>> fetchUsuarios() async {
    final response = await http.get(Uri.parse('https://nodeproyectofluttermdolibre.onrender.com/api/usuarios'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load usuarios');
    }
  }

  Future<void> actualizarUsuario(BuildContext context, dynamic usuario) async {
    final nombreController = TextEditingController(text: usuario['nombre']);
    final cedulaController = TextEditingController(text: usuario['cedula']);
    final correoController = TextEditingController(text: usuario['correo']);
    final telefonoController = TextEditingController(text: usuario['telefono']);
    final direccionController = TextEditingController(text: usuario['direccion']);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Actualizar Usuario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: cedulaController,
                decoration: InputDecoration(labelText: 'Cédula'),
              ),
              TextField(
                controller: correoController,
                decoration: InputDecoration(labelText: 'Correo'),
              ),
              TextField(
                controller: telefonoController,
                decoration: InputDecoration(labelText: 'Teléfono'),
              ),
              TextField(
                controller: direccionController,
                decoration: InputDecoration(labelText: 'Dirección'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final response = await http.put(
                  Uri.parse('https://nodeproyectofluttermdolibre.onrender.com/api/usuarios/${usuario['_id']}'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode({
                    'nombre': nombreController.text,
                    'cedula': cedulaController.text,
                    'correo': correoController.text,
                    'telefono': telefonoController.text,
                    'direccion': direccionController.text,
                  }),
                );

                if (response.statusCode == 200) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Usuario actualizado')));
                  setState(() {
                    _usuariosFuture = fetchUsuarios();
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar usuario')));
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> eliminarUsuario(BuildContext context, dynamic usuario) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Eliminar Usuario'),
          content: Text('¿Estás seguro de que deseas eliminar este usuario?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final response = await http.delete(
        Uri.parse('https://nodeproyectofluttermdolibre.onrender.com/api/usuarios/${usuario['_id']}'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Usuario eliminado')));
        setState(() {
          _usuariosFuture = fetchUsuarios();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al eliminar usuario')));
      }
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
                'https://cdn-icons-png.flaticon.com/512/1535/1535024.png', 
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
                                style: TextStyle(fontSize: 20, color: Colors.lightBlue),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: FutureBuilder<List<dynamic>>(
                            future: _usuariosFuture,
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
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit, color: Colors.grey),
                                            onPressed: () {
                                              actualizarUsuario(context, usuario);
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.grey),
                                            onPressed: () {
                                              eliminarUsuario(context, usuario);
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
