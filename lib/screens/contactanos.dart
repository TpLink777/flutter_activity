import 'package:flutter/material.dart';
import '../main.dart';
import '../core/text_styles.dart';
import '../widget/appBar.dart';
import '../controllers/logic_archive_contactanos.dart';

class Contactanos extends StatefulWidget {
  const Contactanos({super.key});

  @override
  State<Contactanos> createState() => _ContactanosState();
}

class _ContactanosState extends State<Contactanos> {
  final LogicArchiveContactanos logic = LogicArchiveContactanos();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.appBarPersonalizado(
        'Contact us',
        25,
        Colors.white,
        TextAlign.start,
        FontWeight.bold,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextConstructor.styleTxt(
                  '¡Contactate Con Nosotros!',
                  30,
                  Colors.black,
                  TextAlign.center,
                  FontWeight.bold,
                ),
                const SizedBox(height: 50),
                Container(
                  width: 320,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: logic.nombreController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: logic.correoController,
                        decoration: const InputDecoration(
                          labelText: 'Correo',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: logic.mensajeController,
                        decoration: const InputDecoration(
                          labelText: 'Mensaje',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (logic.nombreController.text.trim().isEmpty ||
                              logic.correoController.text.trim().isEmpty ||
                              logic.mensajeController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: TextConstructor.styleTxt(
                                  'Por favor completa todos los campos',
                                  16,
                                  Colors.white,
                                  TextAlign.center,
                                  FontWeight.w600,
                                ),
                                backgroundColor: Colors.redAccent,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return; 
                          }

                          logic.mostrarModal(context);
                        },
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
