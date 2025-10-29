import 'package:flutter/material.dart';
import 'main.dart';

class ExtraData extends StatefulWidget {
  const ExtraData({super.key});

  @override
  State<ExtraData> createState() => _ExtraDataState();
}

class _ExtraDataState extends State<ExtraData> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController direccionController = TextEditingController();
  String? ciudadSeleccionada;
  String? metodoPago;

  final List<String> ciudades = [
    'Medellin',
    'Manrique',
    'Laureles',
    'El Poblado',
  ];

  void limpiarFormulario() {
    direccionController.clear();
    ciudadSeleccionada = null;
    metodoPago = null;
    setState(() {});
  }

  final List<String> metodos = ['Card', 'PayPal', 'Cash on delivery'];

  void enviarFormulario() {
    if (_formKey.currentState!.validate()) {
      if (ciudadSeleccionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecciona una ciudad'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (metodoPago == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecciona un método de pago'),
            backgroundColor: Colors.red,
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
            'Shipping Summary',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Address: ${direccionController.text}'),
              Text('City: $ciudadSeleccionada'),
              Text('payment method: $metodoPago'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                ),
                limpiarFormulario(),
              },
              child: const Text('Accept'),
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
          'Formulario de Envío',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.pink,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(

              width: 300,
              height: 450,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),

              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  children: [
                    // Dirección
                    TextFormField(
                      controller: direccionController,
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
                    DropdownButtonFormField<String>(
                      initialValue: ciudadSeleccionada,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                      items: ciudades
                          .map(
                            (ciudad) => DropdownMenuItem(
                              value: ciudad,
                              child: Text(ciudad),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          ciudadSeleccionada = value;
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
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...metodos.map(
                      (metodo) => RadioListTile<String>(
                        title: Text(metodo),
                        value: metodo,
                        groupValue: metodoPago,
                        onChanged: (value) {
                          setState(() {
                            metodoPago = value;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Botón enviar
                    ElevatedButton(
                      onPressed: enviarFormulario,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Accept',
                        style: TextStyle(fontSize: 18, color: Colors.white),
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
