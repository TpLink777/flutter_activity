import 'package:activity/core/text_styles.dart';
import 'package:flutter/material.dart';
import '../controllers/logic_archive_extra.dart';
import '../widget/appBar.dart';

class ExtraData extends StatefulWidget {
  const ExtraData({super.key});

  @override
  State<ExtraData> createState() => _ExtraDataState();
}

class _ExtraDataState extends State<ExtraData> {

  final LogicArchiveExtra logic = LogicArchiveExtra();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      appBar: AppBarWidget.appBarPersonalizado('Formulario de Envío', 22, Colors.white, TextAlign.center, FontWeight.bold),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  height: 480,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Form(
                    key: logic.formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: ListView(
                      children: [
                        // Dirección
                        TextFormField(
                          controller: logic.direccionController,
                          decoration: const InputDecoration(
                            labelText: 'Address',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu dirección';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Ciudad Dropdown
                        // nos sirve para crear un campo con una lista desplegable de opciones
                        DropdownButtonFormField<String>(
                          initialValue: logic.ciudadSeleccionada,
                          decoration: InputDecoration(
                            labelText: 'City',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(),
                          ),
                          items: logic.ciudades
                              .map(
                                (ciudad) => DropdownMenuItem( //sirve para representar cada opción individual
                                  value: ciudad,
                                  child: Text(ciudad),
                                ),
                              )
                              .toList(), // Convertir la lista de ciudades en una lista de DropdownMenuItem
                          onChanged: (value) {
                            setState(() {
                              logic.ciudadSeleccionada = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Por favor selecciona una ciudad';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Método de pago RadioListTile
                        TextConstructor.styleTxt('Payment Method', 18, Colors.black, TextAlign.start, FontWeight.w500),
                        ...logic.metodos.map(
                          (metodo) => RadioListTile<String>( // sirve para crear una opción de selección única
                            title: Text(metodo),
                            value: metodo,
                            groupValue: logic.metodoPago,
                            onChanged: (value) {
                              setState(() {
                                logic.metodoPago = value;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Botón enviar
                        ElevatedButton(
                          onPressed:  () => logic.enviarFormulario(context, () => setState(() {})),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: TextConstructor.styleTxt('Accept', 20, Colors.white, TextAlign.center, FontWeight.bold),
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
