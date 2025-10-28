import 'package:flutter/material.dart';

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

  final List<String> metodos = ['Tarjeta', 'PayPal', 'Contra entrega'];


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
            'Resumen de Envío',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dirección: ${direccionController.text}'),
              Text('Ciudad: $ciudadSeleccionada'),
              Text('Método de pago: $metodoPago'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Aceptar'),
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
        title: const Text('Formulario de Envío', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: Colors.pink,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              // Dirección
              TextFormField(
                controller: direccionController,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
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
                value: ciudadSeleccionada,
                decoration: const InputDecoration(
                  labelText: 'Ciudad',
                  border: OutlineInputBorder(),
                ),
                items: ciudades
                    .map(
                      (ciudad) =>
                          DropdownMenuItem(value: ciudad, child: Text(ciudad)),
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
                'Método de pago',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  'Enviar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
