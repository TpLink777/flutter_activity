import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/cookieClient.dart';

class LogicArchiveLogIn {

  // local host -> 10.0.2.2
  // red local -> 192.168.1.10
  final String baseUrl = "http://192.168.1.10:5000/api/activity";

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
    var url = Uri.parse("$baseUrl/login");

    final res = await cookieClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'correo': correo,
        'password': password,
      }),
    );

    if(res.statusCode == 200) {
      return jsonDecode(res.body);  
    } else {
      throw Exception("Error: ${res.body}");
    }
  }
}
