/* import 'dart:convert';
import 'package:http/http.dart' as http;

// hacer una solicitud de red usando el metodo get
Future<list<dinamic>>fetchAlbum() async {
  final response = await http.get(Uri.parse('https://nodepracticaflutter-1.onrender.com/api/usuarios'))
if (response.statusCode == 200) {
  return jsonDecode(response.body)
}
else{
  throw Exception('fallas en carga de datos')
}
} */