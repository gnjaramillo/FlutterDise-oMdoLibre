import 'package:flutter/material.dart';
import 'package:mercado_pago_col/src/screens/productos.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart'; // Asegúrate de agregar esta dependencia en pubspec.yaml
import 'dart:typed_data'; // Para manejar datos en memoria (compatible con Flutter Web)
import 'package:http_parser/http_parser.dart';

class AdministracionProductos extends StatelessWidget {
  const AdministracionProductos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar productos'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('Productos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PantallaProductos()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box),
              title: const Text('Agregar Producto'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AgregarProducto()),
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
  String? _categoria;
  int _stockDisponible = 0;
  Uint8List? _imagen; // Ahora es Uint8List para compatibilidad con Flutter Web
  List<dynamic> _categorias = [];

  @override
  void initState() {
    super.initState();
    _fetchCategorias();
  }

  Future<void> _fetchCategorias() async {
    final url = Uri.parse('https://nodeproyectofluttermdolibre.onrender.com/api/categoria/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _categorias = jsonDecode(response.body)['data'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar categorías')),
      );
    }
  }

  Future<void> _agregarProducto() async {
    final url = Uri.parse('https://nodeproyectofluttermdolibre.onrender.com/api/producto/');
    final request = http.MultipartRequest('POST', url)
      ..fields['codigo'] = _codigo
      ..fields['nombre'] = _nombre
      ..fields['descripcion'] = _descripcion
      ..fields['precio'] = _precio.toString()
      ..fields['categoria'] = _categoria!
      ..fields['stockDisponible'] = _stockDisponible.toString();

    if (_imagen != null) {
      final imageFile = http.MultipartFile.fromBytes(
        'foto',
        _imagen!,
        filename: 'imagen_producto.jpg',
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(imageFile);
    }

    final response = await request.send();

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto agregado exitosamente')),
      );
      _formKey.currentState?.reset();
      setState(() {
        _imagen = null;
      });
      Navigator.pop(context); // Regresar a la lista de productos
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al agregar producto')),
      );
    }
  }

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();  // Lee la imagen como bytes
      setState(() {
        _imagen = bytes;
      });
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
                decoration: const InputDecoration(labelText: 'Código'),
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
                decoration: const InputDecoration(labelText: 'Nombre'),
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
                decoration: const InputDecoration(labelText: 'Descripción'),
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
                decoration: const InputDecoration(labelText: 'Precio'),
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
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Categoría'),
                value: _categoria,
                items: _categorias.map((categoria) {
                  return DropdownMenuItem<String>(
                    value: categoria['_id'],
                    child: Text(categoria['nombre']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _categoria = value;
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
                decoration: const InputDecoration(labelText: 'Stock Disponible'),
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
              _imagen != null
                  ? Image.memory(
                      _imagen!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : const Text('No se ha seleccionado ninguna imagen'),
              TextButton(
                onPressed: _seleccionarImagen,
                child: const Text('Seleccionar Imagen'),
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
