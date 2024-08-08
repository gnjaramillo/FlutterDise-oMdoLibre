// pantalla_productos.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PantallaProductos extends StatefulWidget {
  const PantallaProductos({super.key});

  @override
  _PantallaProductosState createState() => _PantallaProductosState();
}

class _PantallaProductosState extends State<PantallaProductos> {
  List productos = [];

  @override
  void initState() {
    super.initState();
    fetchProductos();
  }

  Future<void> fetchProductos() async {
    final response = await http.get(Uri.parse('https://nodeproyectofluttermdolibre.onrender.com/api/producto'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        productos = data['data'];
      });
    } else {
      throw Exception('Error al obtener los productos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        backgroundColor: Colors.brown[700],
      ),
      body: ListView.builder(
        itemCount: productos.length,
        itemBuilder: (context, index) {
          final producto = productos[index];
          return ListTile(
            title: Text(producto['nombre']),
            subtitle: Text('Precio: ${producto['precio']}'),
            trailing: producto['foto'] != null
                ? Image.network(
                    'https://tu-url-publica.com/${producto['foto']['url']}',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image_not_supported),
          );
        },
      ),
    );
  }
}
