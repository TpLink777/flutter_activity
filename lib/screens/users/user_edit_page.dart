import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/user_service.dart';

class UserEditPage extends StatefulWidget {
  final Map<String, dynamic> usuario;
  const UserEditPage({required this.usuario, super.key});

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final _formKey = GlobalKey<FormState>();
  final UserService _service = UserService();

  late TextEditingController _nombreCtrl, _apellidoCtrl, _correoCtrl;

  File? _nuevaImagen;
  String? _imagenActualUrl;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.usuario['nombre']);
    _apellidoCtrl = TextEditingController(text: widget.usuario['apellido']);
    _correoCtrl = TextEditingController(text: widget.usuario['correo']);
    _imagenActualUrl = widget.usuario['image'];
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidoCtrl.dispose();
    _correoCtrl.dispose();
    super.dispose();
  }

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => _nuevaImagen = File(pickedFile.path));
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    final campos = {
      "nombre": _nombreCtrl.text.trim(),
      "apellido": _apellidoCtrl.text.trim(),
      "correo": _correoCtrl.text.trim(),
    };

    final ok = await _service.updateUser(
      id: widget.usuario["id"],
      fields: campos,
      image: _nuevaImagen,
    );

    if (!mounted) return;

    if (ok) {
      Navigator.pop(context, {
        "id": widget.usuario["id"],
        ...campos,
        "image": _imagenActualUrl,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al actualizar el usuario")),
      );
    }

    setState(() => _guardando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        title: const Text(
          'Editar Usuario',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pink,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5F7),
              borderRadius: BorderRadius.circular(20),
            ),

            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _seleccionarImagen,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      backgroundImage: _nuevaImagen != null
                          ? FileImage(_nuevaImagen!)
                          : (_imagenActualUrl != null
                              ? NetworkImage(_imagenActualUrl!)
                              : null) as ImageProvider?,
                      child: _nuevaImagen == null && _imagenActualUrl == null
                          ? const Icon(Icons.camera_alt,
                              color: Colors.pink, size: 50)
                          : null,
                    ),
                  ),

                  const SizedBox(height: 18),
                  Text(
                    'Toca la imagen para cambiarla',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 25),

                  _CampoTexto(
                    controller: _nombreCtrl,
                    label: 'Nombre',
                    icon: Icons.person_outline,
                    validator: (v) => v!.trim().isEmpty ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 12),

                  _CampoTexto(
                    controller: _apellidoCtrl,
                    label: 'Apellido',
                    icon: Icons.badge_outlined,
                    validator: (v) => v!.trim().isEmpty ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 12),

                  _CampoTexto(
                    controller: _correoCtrl,
                    label: 'Correo',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v!.trim().isEmpty) return 'Requerido';
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v))
                        return 'Correo inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.pink.shade200),
                          ),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(color: Colors.pink.shade700),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: _guardando ? null : _guardar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: _guardando
                              ? const CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2)
                              : const Text(
                                  'Guardar',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CampoTexto extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _CampoTexto({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }
}
