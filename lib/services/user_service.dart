import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class UserService {
  // ip -> 192.168.1.10
  // local host ->  10.0.2.2
  static const String baseUrl = 'http:// 10.0.2.2:5000/api/activity';

  // obtener lista
  Future<List<dynamic>> getUsers() async {
    final res = await http
        .get(Uri.parse('$baseUrl/findInformationData'))
        .timeout(const Duration(seconds: 15));

    if (res.statusCode != 200) {
      throw Exception('Error obteniendo usuarios');
    }

    final data = json.decode(res.body);
    return data['data'] ?? [];
  }

  // eliminar
  Future<bool> deleteUser(int id) async {
    final res = await http
        .delete(Uri.parse('$baseUrl/delete-information/$id'))
        .timeout(const Duration(seconds: 15));

    return res.statusCode >= 200 && res.statusCode < 300;
  }

  // actualizar
  Future<bool> updateUser({
    required int id,
    required Map<String, String> fields,
    File? image,
  }) async {
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('$baseUrl/updated-information/$id'),
    );

    request.fields.addAll(fields);

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    final streamed = await request.send();

    return streamed.statusCode >= 200 && streamed.statusCode < 300;

  }
}
