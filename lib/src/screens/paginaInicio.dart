
// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:mercado_pago_col/Menu.dart';


class PaginaInicio extends StatelessWidget {
  const PaginaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Mercado Pago Colombia'),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/inicioSesion');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Iniciar sesión'),
              )
            ],
          )
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
                        borderSide: BorderSide.none
                      ),
                      filled: true,
                      fillColor: Colors.grey[200]
                    ),                       
                  ),        
                ),
                const SizedBox(width: 50),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border_rounded),color:Colors.black,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_sharp),color:Colors.black,
                )
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
                      Navigator.pop(context);},
                      child: Padding(padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(menu[index]['icono'], color:Colors.black),
                          const SizedBox(width: 10),
                          Text(
                            menu[index]['titulo'],
                            textAlign: TextAlign.center,
                            style:const TextStyle(fontSize: 12.0),
                          )
                        ],
                      ),
                      ),
                ),
                );
                }
              ),
            ),
          ],
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
               BottomNavigationBarItem(icon: Icon(Icons.home, size:30.0 ,color: Colors.blue[700]),label:'Inicio'),
               BottomNavigationBarItem(icon: Icon(Icons.shop_2, size:30.0 ,color: Colors.blue[700]),label:'Comprar'),
               BottomNavigationBarItem(icon: Icon(Icons.exit_to_app_rounded, size:30.0 ,color: Colors.blue[700]),label:'Salir')
              ]
        )
      );
  }
} 



