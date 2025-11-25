import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LogicArchiveRegister {
  final formkey = GlobalKey<FormState>();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmarPasswordController =
      TextEditingController();
  bool aceptoTerminos = false;
  File? imagenPerfil;
  bool emailValido = false;
  bool nameValido = false;
  bool apellidoValido = false;
  bool phoneValido = false;
  String seguridadPass = 'Devil';

  bool validadEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool validarNombre(String name) {
    return RegExp(r"^[A-Za-zÁÉÍÓÚÑáéíóúñ\s]{2,}$").hasMatch(name);
  }

  bool validarApellido(String lastname) {
    return RegExp(r"^[A-Za-zÁÉÍÓÚÑáéíóúñ\s]{2,}$").hasMatch(lastname);
  }

  bool validarPass(String pass) {
    return RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$',
    ).hasMatch(pass);
  }

  String evaluarSeguridad(String pass) {
    if (pass.length < 6) return 'Débil';
    if (pass.length < 10) return 'Media';
    if (RegExp(
      r'(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])',
    ).hasMatch(pass)) {
      return 'Fuerte';
    }
    return 'Media';
  }

  double valorSeguridad(String pass) {
    if (pass.length < 6) return 0.33; // Débil
    if (pass.length < 10) return 0.66; // Media
    return 1.0; // Fuerte
  }

  Color colorSeguridad(String pass) {
    if (pass.length < 6) return Colors.red;
    if (pass.length < 10) return Colors.orange;
    return Colors.green;
  }

  Future<void> seleccionarImagen(Function(File?) updateState) async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagen = await picker.pickImage(source: ImageSource.gallery);

    if (imagen != null) {
      imagenPerfil = File(imagen.path);
      updateState(imagenPerfil);
    }
  }

  Future<Map<String, dynamic>> registroUsuario() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.10:5000/api/activity/add-data-contact'),
      );

      request.headers['Content-Type'] = 'multipart/form-data';
      request.fields['nombre'] = nombreController.text;
      request.fields['apellido'] = apellidoController.text;
      request.fields['correo'] = emailController.text;
      request.fields['password'] = passController.text;

      if (imagenPerfil != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', imagenPerfil!.path),
        );
      }

      var res = await request.send();
      var bodyStr = await res.stream.bytesToString();
      var body = json.decode(bodyStr);

      return {"status": res.statusCode, "body": body};
    } catch (e) {
      return {
        "status": 500,
        "body": {"message": e.toString()},
      };
    }
  }

  void limpiarFormulario() {
    nombreController.clear();
    emailController.clear();
    apellidoController.clear();
    passController.clear();
    confirmarPasswordController.clear();
    imagenPerfil = null;
    aceptoTerminos = false;
  }
}
