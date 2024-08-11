//productos.dart


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PantallaProductos extends StatefulWidget {
  const PantallaProductos({super.key});

  @override
  _PantallaProductosState createState() => _PantallaProductosState();
}

class _PantallaProductosState extends State<PantallaProductos> {
  List<dynamic> productos = [];

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
        productos = data['data'] ?? []; // Asegúrate de que sea una lista
      });
    } else {
      throw Exception('Error al obtener los productos');
    }
  }

  Future<void> eliminarProducto(String id) async {
    final url = Uri.parse('https://nodeproyectofluttermdolibre.onrender.com/api/producto/$id');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto eliminado exitosamente')),
      );
      fetchProductos();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar producto')),
      );
    }
  }

  Future<void> mostrarEditarProductoModal(dynamic producto) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditarProductoModal(
          producto: producto,
          onEditComplete: fetchProductos,
        );
      },
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás seguro de que quieres eliminar este producto?'),
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
                  await eliminarProducto(productId);
                  Navigator.of(context).pop();
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
        title: const Text('Productos'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: productos.length,
        itemBuilder: (context, index) {
          final producto = productos[index];
          return ListTile(
            title: Text(producto['nombre'] ?? 'Nombre no disponible'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Código: ${producto['codigo'] ?? 'Código no disponible'}'),
                Text('Descripción: ${producto['descripcion'] ?? 'Descripción no disponible'}'),
                Text('Precio: ${producto['precio'] ?? 'Precio no disponible'}'),
                Text('Categoría: ${producto['categoria']?['nombre'] ?? 'Categoría no disponible'}'),
                Text('Stock Disponible: ${producto['stockDisponible'] ?? 'Stock no disponible'}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => mostrarEditarProductoModal(producto),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _showDeleteConfirmDialog(context, producto['_id'] ?? ''),
                ),
              ],
            ),
            leading: producto['foto'] != null
                ? Image.network(
                    producto['foto']['url'] ?? '',
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

class EditarProductoModal extends StatefulWidget {
  final dynamic producto;
  final VoidCallback onEditComplete;

  const EditarProductoModal({
    Key? key,
    required this.producto,
    required this.onEditComplete,
  }) : super(key: key);

  @override
  _EditarProductoModalState createState() => _EditarProductoModalState();
}

class _EditarProductoModalState extends State<EditarProductoModal> {
  final _formKey = GlobalKey<FormState>();
  late String _codigo, _nombre, _descripcion, _precio, _categoria, _stockDisponible;
  List<dynamic> _categorias = [];

  @override
  void initState() {
    super.initState();
    cargarProductoInicial();
    _fetchCategorias();
  }

  void cargarProductoInicial() {
    _codigo = widget.producto['codigo'] ?? '';
    _nombre = widget.producto['nombre'] ?? '';
    _descripcion = widget.producto['descripcion'] ?? '';
    _precio = widget.producto['precio']?.toString() ?? '';
    _categoria = widget.producto['categoria']['_id'] ?? '';
    _stockDisponible = widget.producto['stockDisponible']?.toString() ?? '';
  }

  Future<void> _fetchCategorias() async {
    final url = Uri.parse('https://nodeproyectofluttermdolibre.onrender.com/api/categoria/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _categorias = data['data'] ?? [];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar categorías')),
      );
    }
  }

  Future<void> _editarProducto() async {
    final url = Uri.parse('https://nodeproyectofluttermdolibre.onrender.com/api/producto/${widget.producto['_id']}');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'codigo': _codigo,
        'nombre': _nombre,
        'descripcion': _descripcion,
        'precio': double.tryParse(_precio) ?? 0.0,
        'categoria': _categoria,
        'stockDisponible': int.tryParse(_stockDisponible) ?? 0,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      widget.onEditComplete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto editado exitosamente')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al editar producto')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Producto'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                initialValue: _codigo,
                decoration: const InputDecoration(labelText: 'Código'),
                onSaved: (value) => _codigo = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un código';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _nombre,
                decoration: const InputDecoration(labelText: 'Nombre'),
                onSaved: (value) => _nombre = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _descripcion,
                decoration: const InputDecoration(labelText: 'Descripción'),
                onSaved: (value) => _descripcion = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _precio,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _precio = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un precio';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _categoria,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: _categorias.map((categoria) {
                  return DropdownMenuItem<String>(
                    value: categoria['_id'],
                    child: Text(categoria['nombre']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _categoria = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione una categoría';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _stockDisponible,
                decoration: const InputDecoration(labelText: 'Stock Disponible'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _stockDisponible = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la cantidad de stock disponible';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              _editarProducto();
            }
          },
          child: const Text('Guardar cambios'),
        ),
      ],
    );
  }
}
