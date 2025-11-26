import 'dart:io';
import 'package:flutter/material.dart';
import '../controllers/logic_archive_registrate.dart';
import '../widget/appBar.dart';
import '../core/input_style.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final LogicArchiveRegister logic = LogicArchiveRegister();
  File? imagen;
  bool _isLoading = false;

  void _seleccionarImagen() {
    logic.seleccionarImagen((img) {
      setState(() {
        imagen = img;
      });
    });
  }

  Future<void> _registrar() async {
    // ✅ Valida formulario
    if (!logic.formkey.currentState!.validate()) {
      print("❌ Formulario no válido");
      return;
    }

    // ✅ Valida términos
    if (!logic.aceptoTerminos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Debes aceptar los términos y condiciones"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ✅ Valida imagen
    if (logic.imagenPerfil == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor selecciona una imagen de perfil"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      print("🚀 Llamando a registroUsuario()...");
      var res = await logic.registroUsuario();

      print("📊 Respuesta: $res");

      if (!mounted) return; // Verifica que el widget aún esté montado

      // ✅ Verifica si fue exitoso
      if (res["success"] == true) {

        // Muestra diálogo de éxito
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              "¡Registro Exitoso!",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              "Bienvenido ${logic.nombreController.text.toUpperCase()}",
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  Navigator.pop(context); // Cierra diálogo
                  Navigator.pop(context); // Regresa a login
                },
                child: const Text(
                  "Continuar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );

        logic.limpiarFormulario();
      } else {
        print("❌ Error en respuesta: ${res['body']}");

        // Muestra error
        String errorMsg = res["body"]?["message"] ?? "Error desconocido";

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $errorMsg"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("❌ Excepción en _registrar: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error inesperado: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      appBar: AppBarWidget.appBarPersonalizado(
        "¡Registrate!",
        25,
        Colors.white,
        TextAlign.center,
        FontWeight.bold,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _seleccionarImagen,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: imagen != null ? FileImage(imagen!) : null,
                    child: imagen == null
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
                    key: logic.formkey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: ListView(
                      children: [
                        TextFormField(
                          controller: logic.nombreController,
                          decoration: InputStyleWidget.inputDecorationStyle(
                            'Ingresa tu nombre',
                            logic.nameValido,
                          ),

                          onChanged: (value) {
                            setState(() {
                              logic.nameValido = logic.validarNombre(value);
                            });
                          },

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu nombre';
                            }

                            if (!logic.validarNombre(value)) {
                              return 'El nombre solo debe de contener letras y espacios';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: logic.apellidoController,
                          decoration: InputStyleWidget.inputDecorationStyle(
                            'Ingresa tu apellido',
                            logic.apellidoValido,
                          ),

                          onChanged: (value) {
                            setState(() {
                              logic.apellidoValido = logic.validarApellido(
                                value,
                              );
                            });
                          },

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu apellido';
                            }

                            if (!logic.validarApellido(value)) {
                              return 'El apellido solo debe de contener letras y espacios';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: logic.emailController,
                          decoration: InputStyleWidget.inputDecorationStyle(
                            'Ingresa tu email',
                            logic.emailValido,
                          ),

                          onChanged: (value) {
                            setState(() {
                              logic.emailValido = logic.validadEmail(value);
                            });
                          },

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu email';
                            }

                            if (!logic.validadEmail(value)) {
                              return 'Por favor ingresa un email con formato válido';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),
                        TextFormField(
                          controller: logic.passController,
                          decoration: InputStyleBasic.inputDecorationSimple(
                            'Ingresa tu contraseña',
                          ),

                          onChanged: (value) {
                            setState(() {
                              logic.seguridadPass = logic.evaluarSeguridad(
                                value,
                              );
                            });
                          },
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu contraseña';
                            }
                            if (!logic.validarPass(value)) {
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
                            value: logic.valorSeguridad(
                              logic.passController.text,
                            ),
                            color: logic.colorSeguridad(
                              logic.passController.text,
                            ),
                            backgroundColor: Colors.grey[200],
                            minHeight: 8, // Altura del indicador
                          ),
                        ),

                        const SizedBox(height: 20),
                        TextFormField(
                          controller: logic.confirmarPasswordController,
                          decoration: InputStyleBasic.inputDecorationSimple(
                            'Confirma tu contraseña',
                          ),

                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor confirma tu contraseña';
                            }
                            if (!logic.validarPass(value)) {
                              return 'Debe tener al menos 8 caracteres, una mayúscula, una minúscula y un número';
                            }
                            if (value != logic.passController.text) {
                              return 'Las contraseñas deben de ser iguales';
                            }

                            return null;
                          },
                        ),

                        CheckboxListTile(
                          title: const Text('Aceptar términos y condiciones'),
                          activeColor: Colors.pink,
                          value: logic.aceptoTerminos,
                          onChanged: (bool? valor) {
                            setState(() {
                              logic.aceptoTerminos = valor ?? false;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),

                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _registrar,
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
