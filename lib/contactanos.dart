import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class Contactanos extends StatefulWidget {
  const Contactanos({super.key});

  @override
  State<Contactanos> createState() => _ContactanosState();
}

class _ContactanosState extends State<Contactanos> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController mensajeController = TextEditingController();
  bool nameValido = false;
  bool apellidoValido = false;
  bool correoValido = false;

  void limpiarFormulario() {
    nombreController.clear();
    apellidoController.clear();
    correoController.clear();
    mensajeController.clear();
  }

  bool validarNombre(String name) {
    return RegExp(r"^[A-Za-zÁÉÍÓÚÑáéíóúñ\s]{2,}$").hasMatch(name);
  }

  bool validarApellido(String lastname) {
    return RegExp(r"^[A-Za-zÁÉÍÓÚÑáéíóúñ\s]{4,}$").hasMatch(lastname);
  }

  bool validarCorreo(String correo) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(correo);
  }

  Future<void> enviarDatos() async {
    final url = Uri.parse(
      'http://192.168.1.10:5000/api/activity/add-data-contact',
    );// Android emulator usa 10.0.2.2 para localhost

    
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({ // Convertir a JSON
        'nombre': nombreController.text,
        'apellido': apellidoController.text,
        'correo': correoController.text,
        'mensaje': mensajeController.text,
      }),
    );

    if (_formkey.currentState!.validate() && res.statusCode == 201) {
      String nombre = nombreController.text;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),

          title: const Text(
            'Datos Enviados Exitosamente',
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
                'Gracias ${nombre.toUpperCase()} pronto seras parte de la familia 🌈',
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
      print('Error al enviar datos: ${res.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contact us',
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
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            
                Text('¡Contactate Con Nosotros!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            
                const SizedBox(height: 50),
                Container(
                  width: 320,
                  height: 380,
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
                          controller: apellidoController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
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
                          controller: correoController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: 'Ingresa tu email',
                            labelStyle: TextStyle(color: Colors.black),
                            suffixIcon: correoValido
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
                              correoValido = validarCorreo(value);
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
            
                            if (!validarCorreo(value)) {
                              return 'Por favor ingresa un email con formato válido';
                            }
                            return null;
                          },
                        ),
            
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: mensajeController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: 'Ingresa tu mensaje',
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu mensaje';
                            }
                            if (value.length < 10) {
                              return 'El mensaje debe ser mas largo.';
                            }
                            if (value.length > 200) {
                              return 'El mensaje debe ser mas corto.';
                            }
                            return null;
                          },
                        ),
            
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: enviarDatos,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          child: const Text(
                            '¡Enviar! 🚀',
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
