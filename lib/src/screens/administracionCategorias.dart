// administracionCategorias.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdministracionCategorias extends StatefulWidget {
  const AdministracionCategorias({super.key});

  @override
  _AdministracionCategoriasState createState() => _AdministracionCategoriasState();
}

class _AdministracionCategoriasState extends State<AdministracionCategorias> {
  late Future<List<dynamic>> _categoriasFuture;

  @override
  void initState() {
    super.initState();
    _categoriasFuture = fetchCategorias();
  }

  Future<List<dynamic>> fetchCategorias() async {
    final response = await http.get(Uri.parse('https://nodeproyectofluttermdolibre.onrender.com/api/categoria'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load categorias');
    }
  }

  Future<void> actualizarCategoria(dynamic categoria) async {
    final nombreController = TextEditingController(text: categoria['nombre']);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Actualizar Categoría'),
          content: TextField(
            controller: nombreController,
            decoration: InputDecoration(labelText: 'Nombre'),
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
                  Uri.parse('https://nodeproyectofluttermdolibre.onrender.com/api/categoria/${categoria['_id']}'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode({'nombre': nombreController.text}),
                );

                if (response.statusCode == 200) {
                  setState(() {
                    _categoriasFuture = fetchCategorias();
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Categoría actualizada')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar categoría')));
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> eliminarCategoria(dynamic categoria) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Eliminar Categoría'),
          content: Text('¿Estás seguro de que deseas eliminar esta categoría?'),
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
        Uri.parse('https://nodeproyectofluttermdolibre.onrender.com/api/categoria/${categoria['_id']}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _categoriasFuture = fetchCategorias();
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Categoría eliminada')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al eliminar categoría')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Categorías'),
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _categoriasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay categorías disponibles'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final categoria = snapshot.data![index];
                return ListTile(
                  title: Text(categoria['nombre']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.grey),
                        onPressed: () {
                          actualizarCategoria(categoria);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey),
                        onPressed: () {
                          eliminarCategoria(categoria);
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
