import 'dart:io';
import 'package:activity/screens/registrate.dart';
import 'package:flutter/material.dart';
import '../controllers/logic_archive_login.dart';
import '../widget/appBar.dart';
import '../core/input_style.dart';
import '../core/text_styles.dart';
import '../models/cookieClient.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LogicArchiveLogIn logic = LogicArchiveLogIn();
  File? imagen;

  Future<void> _login() async {
    try {
      final data = await LogicArchiveLogIn().login(
        logic.emailController.text.trim(),
        logic.passController.text.trim(),
      );

      print("Respuesta login: $data");
      // Y navegas a la home
      Navigator.pushReplacementNamed(context, '/viewUser');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Correo o contraseña incorrectos")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      appBar: AppBarWidget.appBarPersonalizado(
        "Inicia Sesión!",
        25,
        Colors.white,
        TextAlign.center,
        FontWeight.bold,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Center(
            child: Column(
              children: [
                TextConstructor.styleTxt(
                  'Bienvenido de nuevo',
                  28,
                  Colors.black,
                  TextAlign.center,
                  FontWeight.bold,
                ),

                const SizedBox(height: 10),

                TextConstructor.styleTxt(
                  'Inicia sesión para continuar',
                  16,
                  Colors.grey,
                  TextAlign.center,
                  FontWeight.w500,
                ),

                const SizedBox(height: 40),

                // TARJETA
                Container(
                  width: 340,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: Colors.black12),
                  ),

                  child: Form(
                    key: logic.formkey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextConstructor.styleTxt(
                          "Correo Electrónico",
                          15,
                          Colors.black,
                          TextAlign.start,
                          FontWeight.w600,
                        ),
                        const SizedBox(height: 6),

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
                              return 'Por favor ingresa un email válido';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 22),

                        TextConstructor.styleTxt(
                          "Contraseña",
                          15,
                          Colors.black,
                          TextAlign.start,
                          FontWeight.w600,
                        ),
                        const SizedBox(height: 6),

                        TextFormField(
                          controller: logic.passController,
                          decoration: InputStyleBasic.inputDecorationSimple(
                            'Ingresa tu contraseña',
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu contraseña';
                            }
                            if (!logic.validarPass(value)) {
                              return 'Debe tener 8 caracteres, una mayúscula, una minúscula y un número';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: TextConstructor.styleTxt(
                              'Iniciar Sesión',
                              18,
                              Colors.white,
                              TextAlign.center,
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Registro()),
                    );
                  },
                  child: TextConstructor.styleTxt(
                    '¿No tienes una cuenta? Regístrate',
                    16,
                    Colors.grey,
                    TextAlign.center,
                    FontWeight.w500,
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
