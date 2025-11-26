import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/cookieClient.dart';

class LogicArchiveLogIn {
  // local host -> 10.0.2.2
  // red local -> 192.168.1.10 || 192.168.1.4
  final String baseUrl = "http://192.168.1.4:5000/api/activity";

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool emailValido = false;

  bool validadEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool validarPass(String pass) {
    return RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$',
    ).hasMatch(pass);
  }

  Future<Map<String, dynamic>> login(String correo, String password) async {
    try {
      print("📝 Iniciando login...");
      var url = Uri.parse("$baseUrl/login");

      final res = await cookieClient
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'correo': correo, 'password': password}),
          )
          .timeout(const Duration(seconds: 15));

      print("📥 Status: ${res.statusCode}");
      print("🍪 Cookie recibida: ${res.headers['set-cookie']}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        print("📄 Respuesta completa: $data");

        // ✅ Extrae los campos correctos
        final userId = data['data']?['id'] ?? 0;
        final userName = data['data']?['nombre'] ?? '';
        final userCorreo = data['data']?['correo'] ?? correo;

        print("👤 Datos extraídos:");
        print("   ID: $userId");
        print("   Nombre: $userName");
        print("   Correo: $userCorreo");

        if (userId == 0) {
          print("⚠️ ADVERTENCIA: ID de usuario es 0");
        }

        // ✅ Guarda con los nombres correctos
        cookieClient.setUser(
          id: userId,
          nombre: userName, // ✅ "nombre"
          correo: userCorreo, // ✅ "correo"
        );

        cookieClient.printStatus();

        return data;
      } else {
        print("❌ Error: ${res.body}");
        throw Exception("Credenciales incorrectas");
      }
    } catch (e) {
      print("❌ Excepción en login: $e");
      throw Exception("Error: $e");
    }
  }
}
