import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmarPasswordController =
      TextEditingController();
  bool aceptoTerminos = false;
  File? _imagenPerfil;
  bool emailValido = false;
  bool nameValido = false;
  bool apellidoValido = false;
  bool phoneValido = false;
  String seguridadPass = 'Devil';

  void limpiarFormulario() {
    nombreController.clear();
    emailController.clear();
    apellidoController.clear();
    passController.clear();
    confirmarPasswordController.clear();
    _imagenPerfil = null;
    setState(() {
      aceptoTerminos = false;
    });
  }

  bool validadEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool validarNombre(String name) {
    return RegExp(r"^[A-Za-zÁÉÍÓÚÑáéíóúñ\s]{2,}$").hasMatch(name);
  }

  bool validarApellido(String lastname) {
    return RegExp(r"^[A-Za-zÁÉÍÓÚÑáéíóúñ\s]{2,}$").hasMatch(lastname);
  }

  bool validarTelefono(String phone) {
    return RegExp(r'^\d{10}$').hasMatch(phone);
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

  Future<void> seleccionarImagen() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagen = await picker.pickImage(source: ImageSource.gallery);

    if (imagen != null) {
      setState(() {
        _imagenPerfil = File(imagen.path);
      });
    }
  }

  void registroUsuario() async {
    if (_formkey.currentState!.validate()) {
      String nombre = nombreController.text;
      String apellido = apellidoController.text;
      String correo = emailController.text;
      String password = passController.text;

      if (!aceptoTerminos) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Debes aceptar los términos y condiciones',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      if (_imagenPerfil == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Debes de seleccionar una imagen',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://10.0.2.2:5000/api/activity/add-data-contact'),
        );

        // Agregar campos del formulario
        request.fields['nombre'] = nombre;
        request.fields['apellido'] = apellido;
        request.fields['correo'] = correo;
        request.fields['password'] = password;

        // Agregar imagen
        request.files.add(
          await http.MultipartFile.fromPath('image', _imagenPerfil!.path),
        );

        var response = await request.send();

        if (response.statusCode == 201) {
          var respStr = await response.stream.bytesToString();
          var data = json.decode(respStr);

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Text(
                'Registro Exitoso',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.green,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 80),
                  const SizedBox(height: 16),
                  Text(
                    'Bienvenido ${nombre.toUpperCase()} ahora eres parte de la familia',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    limpiarFormulario();
                  },
                  child: const Text(
                    'Aceptar',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          var respStr = await response.stream.bytesToString();
          var data = json.decode(respStr);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error: ${data['message'] ?? 'No se pudo registrar'}',
                style: const TextStyle(fontSize: 18),
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ocurrió un error: $e',
              style: const TextStyle(fontSize: 18),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      appBar: AppBar(
        title: const Text(
          '¡Registrate!',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.pink,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: seleccionarImagen,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imagenPerfil != null
                        ? FileImage(_imagenPerfil!)
                        : null,
                    child: _imagenPerfil == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                ),
                const SizedBox(height: 50),

                Container(
                  width: 320,
                  height: 500,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Form(
                    key: _formkey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: ListView(
                      children: [
                        TextFormField(
                          controller: nombreController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: 'Ingresa tu nombre',
                            labelStyle: TextStyle(color: Colors.black),
                            suffixIcon: nameValido
                                ? const Icon(
                                    Icons.check_circle_outlined,
                                    color: Colors.green,
                                  )
                                : const Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.red,
                                  ),
                          ),

                          onChanged: (value) {
                            setState(() {
                              nameValido = validarNombre(value);
                            });
                          },

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu nombre';
                            }

                            if (!RegExp(
                              r"^[A-Za-zÁÉÍÓÚÑáéíóúñ\s]{2,}$",
                            ).hasMatch(value)) {
                              return 'El nombre solo debe de contener letras y espacios';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: apellidoController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: 'Ingresa tu apellido',
                            labelStyle: TextStyle(color: Colors.black),
                            suffixIcon: apellidoValido
                                ? const Icon(
                                    Icons.check_circle_outlined,
                                    color: Colors.green,
                                  )
                                : const Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.red,
                                  ),
                          ),

                          onChanged: (value) {
                            setState(() {
                              apellidoValido = validarApellido(value);
                            });
                          },

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu apellido';
                            }

                            if (!RegExp(
                              r"^[A-Za-zÁÉÍÓÚÑáéíóúñ\s]{2,}$",
                            ).hasMatch(value)) {
                              return 'El apellido solo debe de contener letras y espacios';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: 'Ingresa tu email',
                            labelStyle: TextStyle(color: Colors.black),
                            suffixIcon: emailValido
                                ? const Icon(
                                    Icons.check_circle_outlined,
                                    color: Colors.green,
                                  )
                                : const Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.red,
                                  ),
                          ),

                          onChanged: (value) {
                            setState(() {
                              emailValido = validadEmail(value);
                            });
                          },

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu email';
                            }
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value)) {
                              return 'Por favor ingresa un email con formato valido';
                            }

                            if (!validadEmail(value)) {
                              return 'Por favor ingresa un email con formato válido';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),
                        TextFormField(
                          controller: passController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: 'Ingresa tu contraseña',
                            labelStyle: TextStyle(color: Colors.black),
                          ),

                          onChanged: (value) {
                            setState(() {
                              seguridadPass = evaluarSeguridad(value);
                            });
                          },
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu contraseña';
                            }
                            if (!RegExp(
                              r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$',
                            ).hasMatch(value)) {
                              return 'Debe tener al menos 8 caracteres, una mayúscula, una minúscula y un número';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 10),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            16,
                          ), // Bordes redondeados
                          child: LinearProgressIndicator(
                            value: valorSeguridad(passController.text),
                            color: colorSeguridad(passController.text),
                            backgroundColor: Colors.grey[200],
                            minHeight: 8, // Altura del indicador
                          ),
                        ),

                        const SizedBox(height: 20),
                        TextFormField(
                          controller: confirmarPasswordController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: 'Confirma tu contraseña',
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor confirma tu contraseña';
                            }
                            if (!RegExp(
                              r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$',
                            ).hasMatch(value)) {
                              return 'Debe tener al menos 8 caracteres, una mayúscula, una minúscula y un número';
                            }
                            if (value != passController.text) {
                              return 'Las contraseñas deben de ser iguales';
                            }

                            return null;
                          },
                        ),

                        CheckboxListTile(
                          title: const Text('Aceptar términos y condiciones'),
                          activeColor: Colors.pink,
                          value: aceptoTerminos,
                          onChanged: (bool? valor) {
                            setState(() {
                              aceptoTerminos = valor ?? false;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: registroUsuario,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          child: const Text(
                            'Registrar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
