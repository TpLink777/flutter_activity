import 'package:flutter/material.dart';

class LogicArchiveExtra {
  // Controladores y estados
  final formKey = GlobalKey<FormState>();
  final TextEditingController direccionController = TextEditingController();

  String? ciudadSeleccionada;
  String? metodoPago;

  final List<String> ciudades = [
    'Medellín',
    'Cali',
    'Manizales',
    'Pereira',
    'Bogotá',
  ];

  final List<String> metodos = [
    'Card',
    'PayPal',
    'Cash on delivery',
  ];

  void limpiarFormulario(VoidCallback actualizarUI) {
    direccionController.clear();
    ciudadSeleccionada = null;
    metodoPago = null;
    actualizarUI(); // función pasada desde el widget que hace setState
  }

  // VoidCallback sirve para pasar una función sin parámetros ni valor de retorno

  void enviarFormulario(BuildContext context, VoidCallback actualizarUI) {

    if (formKey.currentState!.validate()) {
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
            'Resumen de envío',
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
              onPressed: () {
                Navigator.pop(context);
                limpiarFormulario(actualizarUI);
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );

    }
  }
}
