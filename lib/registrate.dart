import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmarPasswordController =
      TextEditingController();
  bool aceptoTerminos = false;
  File? _imagenPerfil;
  bool emailValido = false;
  bool nameValido = false;
  bool phoneValido = false;
  String seguridadPass = 'Devil';

  void limpiarFormulario() {
    nombreController.clear();
    emailController.clear();
    telefonoController.clear();
    passController.clear();
    confirmarPasswordController.clear();
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

  void registroUsuario() {
    if (_formkey.currentState!.validate()) {
      String nombre = nombreController.text;

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

      body: Center(
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
              height: 480,
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
                          borderRadius: BorderRadius.all(Radius.circular(15)),
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
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
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
                      controller: telefonoController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelText: 'Ingresa tu teléfono',
                        labelStyle: TextStyle(color: Colors.black),
                        suffixIcon: phoneValido
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
                          phoneValido = validarTelefono(value);
                        });
                      },

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu teléfono';
                        }
                        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'El teléfono debe tener 10 dígitos';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
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
                          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&])[A-Za-z\d$@$!%*?&]{8,15}$',
                        ).hasMatch(value)) {
                          return 'Debe tener al menos 8 caracteres, una letra, un número y un carácter especial';
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
                        minHeight: 8,
                      ),
                    ),

                    const SizedBox(height: 20),
                    TextFormField(
                      controller: confirmarPasswordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
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
                          r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{10,}$',
                        ).hasMatch(value)) {
                          return 'Debe tener al menos 10 caracteres, una letra y un número';
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
    );
  }
}
