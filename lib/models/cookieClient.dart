// models/cookieClient.dart
import 'package:http/http.dart' as http;

class CookieClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  // ✅ Variables para manejar autenticación
  String? cookie;
  int? userId; // ✅ ID del usuario
  String? userName; // ✅ Nombre del usuario
  String? userCorreo; // ✅ Correo del usuario

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    // Adjunta la cookie si existe
    if (cookie != null) {
      request.headers['Cookie'] = cookie!;
    }

    return _inner.send(request).then((response) {
      // Captura la cookie de la respuesta
      final setCookie = response.headers['set-cookie'];
      if (setCookie != null) {
        cookie = setCookie;
        print("🍪 Cookie guardada: $setCookie");
      }
      return response;
    });
  }

  // ✅ Guardar información del usuario después de login/registro
  void setUser({
    required int id,
    required String nombre, // ✅ Cambiado de "name" a "nombre"
    String? correo, // ✅ Cambiado de "email" a "correo"
  }) {
    userId = id;
    userName = nombre;
    userCorreo = correo;
    print("✅ Usuario guardado en CookieClient:");
    print("   ID: $userId");
    print("   Nombre: $userName");
    print("   Correo: $userCorreo");
  }

  // ✅ Limpiar datos cuando el usuario cierra sesión
  void logout() {
    userId = null;
    userName = null;
    userCorreo = null;
    cookie = null;
    print("🚪 Usuario deslogueado - CookieClient limpio");
  }

  // ✅ Verificar si hay un usuario autenticado
  bool get isAuthenticated => userId != null && cookie != null;

  // ✅ Obtener info del usuario
  Map<String, dynamic>? get userInfo {
    if (!isAuthenticated) return null;
    return {'id': userId, 'nombre': userName, 'correo': userCorreo};
  }

  // ✅ Debug info
  void printStatus() {
    print("📊 Estado del CookieClient:");
    print("   Autenticado: $isAuthenticated");
    print("   User ID: $userId");
    print("   User Nombre: $userName");
    print("   User Correo: $userCorreo");
    print("   Cookie: ${cookie != null ? 'Sí' : 'No'}");
  }
}

// ✅ Instancia global
final cookieClient = CookieClient();
