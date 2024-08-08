// administracion_productos.dart

import 'package:flutter/material.dart';
import 'package:mercado_pago_col/src/screens/productos.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AdministracionProductos extends StatelessWidget {
  const AdministracionProductos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar productos'),
        backgroundColor: Colors.blue, // Puedes ajustar el color según tus preferencias
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.list_alt),
              title: Text('Productos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PantallaProductos()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add_box),
              title: Text('Agregar Producto'),
              onTap: () {
                // Navegar a la pantalla de agregar producto
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AgregarProducto()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Eliminar Producto'),
              onTap: () {
                // Navegar a la pantalla de eliminar producto
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EliminarProducto()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}



class AgregarProducto extends StatefulWidget {
  const AgregarProducto({super.key});

  @override
  _AgregarProductoState createState() => _AgregarProductoState();
}

class _AgregarProductoState extends State<AgregarProducto> {
  final _formKey = GlobalKey<FormState>();
  String _codigo = '';
  String _nombre = '';
  String _descripcion = '';
  double _precio = 0.0;
  String _categoria = '';
  int _stockDisponible = 0;

  Future<void> _agregarProducto() async {
    final url = Uri.parse('http://localhost:3030/api/producto/');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'codigo': _codigo,
        'nombre': _nombre,
        'descripcion': _descripcion,
        'precio': _precio,
        'categoria': _categoria,
        'stockDisponible': _stockDisponible,
      }),
    );

    if (response.statusCode == 200) {
      // Si la solicitud fue exitosa, muestra un mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Producto agregado exitosamente')),
      );
    } else {
      // Si la solicitud falló, muestra un mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar producto')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Producto'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Código'),
                onSaved: (value) {
                  _codigo = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un código';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                onSaved: (value) {
                  _nombre = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descripción'),
                onSaved: (value) {
                  _descripcion = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _precio = double.parse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un precio';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Categoría'),
                onSaved: (value) {
                  _categoria = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una categoría';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Stock Disponible'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _stockDisponible = int.parse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la cantidad de stock disponible';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _agregarProducto();
                  }
                },
                child: const Text('Agregar Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class EliminarProducto extends StatefulWidget {
  const EliminarProducto({super.key});

  @override
  _EliminarProductoState createState() => _EliminarProductoState();
}

class _EliminarProductoState extends State<EliminarProducto> {
  final _formKey = GlobalKey<FormState>();
  String _productoId = '';

  Future<void> _eliminarProducto() async {
    final url = Uri.parse('http://localhost:3030/api/producto/$_productoId');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      // Si la solicitud fue exitosa, muestra un mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Producto eliminado exitosamente')),
      );
    } else {
      // Si la solicitud falló, muestra un mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar producto')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eliminar Producto'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'ID del Producto'),
                onSaved: (value) {
                  _productoId = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el ID del producto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _eliminarProducto();
                  }
                },
                child: const Text('Eliminar Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
