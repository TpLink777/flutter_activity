import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/cookieClient.dart';

class UserService {
  static const String baseUrl = 'http://192.168.1.4:5000/api/activity';

  // ✅ Obtener usuario por ID (requiere autenticación)
  Future<UserModel> getUserById(int id) async {
    try {
      print("\n🔍 === getUserById Iniciado ===");
      print("   ID solicitado: $id");
      print("   URL: $baseUrl/findInformationDataById/$id");

      // ✅ Verifica autenticación ANTES de hacer la petición
      if (!cookieClient.isAuthenticated) {
        throw Exception('No hay usuario autenticado. Inicia sesión primero.');
      }

      print("   ✅ Usuario autenticado");
      print("   🍪 Cookie: ${cookieClient.cookie}");
      print("   👤 User ID en memoria: ${cookieClient.userId}");

      final res = await cookieClient
          .get(Uri.parse('$baseUrl/findInformationDataById/$id'))
          .timeout(const Duration(seconds: 15));

      print("   📥 Status Code: ${res.statusCode}");
      print("   📄 Response Body: ${res.body}");

      if (res.statusCode == 401) {
        throw Exception('No autorizado. Token inválido o expirado.');
      }

      if (res.statusCode == 404) {
        throw Exception('Usuario no encontrado con ID: $id');
      }

      if (res.statusCode != 200) {
        throw Exception('Error ${res.statusCode}: ${res.body}');
      }

      final data = json.decode(res.body);
      print("   📊 Data decodificada: $data");

      // ✅ Verifica estructura de respuesta
      if (data['data'] == null) {
        throw Exception('Respuesta vacía del servidor');
      }

      print("   ✅ Parseando a UserModel...");
      final user = UserModel.fromJson(data['data']);
      print("   ✅ Usuario obtenido: ${user.toString()}");
      print("=== getUserById Completado ===\n");

      return user;
    } catch (e) {
      print("   ❌ Error en getUserById: $e");
      print("=== getUserById Falló ===\n");
      rethrow; // Re-lanza la excepción para manejarla en la UI
    }
  }

  Future<bool> deleteUser(int id) async {
    try {
      print("🗑️ Eliminando usuario con ID: $id");

      if (!cookieClient.isAuthenticated) {
        throw Exception('No autorizado');
      }

      final res = await cookieClient
          .delete(Uri.parse('$baseUrl/delete-information/$id'))
          .timeout(const Duration(seconds: 15));

      print("📥 Status Code: ${res.statusCode}");

      final success = res.statusCode >= 200 && res.statusCode < 300;
      print(success ? "✅ Usuario eliminado" : "❌ Error al eliminar");

      return success;
    } catch (e) {
      print("❌ Error en deleteUser: $e");
      rethrow;
    }
  }

  Future<bool> updateUser({
    required int id,
    required Map<String, String> fields,
    File? image,
  }) async {
    try {
      print("✏️ Actualizando usuario con ID: $id");
      print("📝 Campos: $fields");

      if (!cookieClient.isAuthenticated) {
        throw Exception('No autorizado');
      }

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/updated-information/$id'),
      );

      request.fields.addAll(fields);

      if (image != null) {
        print("📸 Adjuntando imagen: ${image.path}");
        request.files.add(
          await http.MultipartFile.fromPath('image', image.path),
        );
      }

      // ✅ Asegúrate de enviar la cookie
      if (cookieClient.cookie != null) {
        request.headers['Cookie'] = cookieClient.cookie!;
        print("🍪 Cookie adjunta");
      }

      print("📤 Enviando request...");
      final streamed = await request.send();
      print("📥 Status Code: ${streamed.statusCode}");

      final success = streamed.statusCode >= 200 && streamed.statusCode < 300;
      print(success ? "✅ Usuario actualizado" : "❌ Error al actualizar");

      return success;
    } catch (e) {
      print("❌ Error en updateUser: $e");
      rethrow;
    }
  }
}
