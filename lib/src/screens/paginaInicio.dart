// paginaInicio.dart
import 'package:flutter/material.dart';
import 'package:mercado_pago_col/Menu.dart';
import 'productos.dart';

class PaginaInicio extends StatelessWidget {
  const PaginaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Mercado Pago Colombia'),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/administracionUsuarios');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Colors.brown[100],
                      foregroundColor: Colors.brown[800],
                    ),
                    child: const Text('Admin Usuarios'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/administracionProductos');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Colors.brown[100],
                      foregroundColor: Colors.brown[800],
                    ),
                    child: const Text('Admin Productos'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/inicioSesion');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Colors.brown[100],
                      foregroundColor: Colors.brown[800],
                    ),
                    child: const Text('Iniciar sesión'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ), 
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Buscar producto',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.brown[50],
                    ),                       
                  ),        
                ),
                const SizedBox(width: 50),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border_rounded),
                  color: Colors.brown[800],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_sharp),
                  color: Colors.brown[800],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: menu.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 2.0,
                    margin: const EdgeInsets.all(5),
                    child: InkWell(
                      onTap: () {
                        if (menu[index]['titulo'] == 'Usuarios') {
                          Navigator.pushNamed(context, '/administracionUsuarios');
                        } else if (menu[index]['titulo'] == 'Hogar') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PantallaProductos()),
                          );
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(menu[index]['icono'], color: Colors.brown[800]),
                            const SizedBox(width: 10),
                            Text(
                              menu[index]['titulo'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Color.fromRGBO(78, 52, 46, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30.0, color: Colors.brown[700]),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop_2, size: 30.0, color: Colors.brown[700]),
            label: 'Comprar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app_rounded, size: 30.0, color: Colors.brown[700]),
            label: 'Salir',
          ),
        ],
      ),
    );
  }
}



