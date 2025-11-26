import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user_model.dart';
import '../../models/cookieClient.dart';
import '../../services/user_service.dart';

class UserEditPage extends StatefulWidget {
  final UserModel usuario;
  
  const UserEditPage({
    required this.usuario,
    super.key,
  });

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final _formKey = GlobalKey<FormState>();
  final UserService _service = UserService();

  late TextEditingController _nombreCtrl;
  late TextEditingController _apellidoCtrl;
  late TextEditingController _correoCtrl;

  File? _nuevaImagen;
  String? _imagenActualUrl;
  bool _guardando = false;
  bool _eliminando = false;

  @override
  void initState() {
    super.initState();
    
    _nombreCtrl = TextEditingController(text: widget.usuario.nombre);
    _apellidoCtrl = TextEditingController(text: widget.usuario.apellido);
    _correoCtrl = TextEditingController(text: widget.usuario.correo);
    _imagenActualUrl = widget.usuario.imageUrl;
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

    try {
      final campos = {
        "nombre": _nombreCtrl.text.trim(),
        "apellido": _apellidoCtrl.text.trim(),
        "correo": _correoCtrl.text.trim(),
      };

      final ok = await _service.updateUser(
        id: widget.usuario.id,
        fields: campos,
        image: _nuevaImagen,
      );

      if (!mounted) return;

      if (ok) {
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil actualizado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true);
      } else {
        throw Exception('Error al actualizar');
      }
    } catch (e) {
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al actualizar: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _guardando = false);
      }
    }
  }

  Future<void> _confirmarEliminar() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 30),
            SizedBox(width: 12),
            Text(
              '¿Eliminar cuenta?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'Esta acción es irreversible. Se eliminarán todos tus datos permanentemente.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await _eliminarCuenta();
    }
  }

  Future<void> _eliminarCuenta() async {
    setState(() => _eliminando = true);

    try {
      
      final ok = await _service.deleteUser(widget.usuario.id);

      if (!mounted) return;

      if (ok) {
        
        
        // ✅ Limpia la sesión
        cookieClient.logout();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cuenta eliminada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );

        // ✅ Navega al login y limpia el stack
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      } else {
        throw Exception('No se pudo eliminar la cuenta');
      }
    } catch (e) {
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al eliminar cuenta: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _eliminando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Editar Perfil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
                  // Avatar
                  GestureDetector(
                    onTap: _guardando || _eliminando ? null : _seleccionarImagen,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          backgroundImage: _nuevaImagen != null
                              ? FileImage(_nuevaImagen!)
                              : (_imagenActualUrl != null &&
                                      _imagenActualUrl!.isNotEmpty
                                  ? NetworkImage(
                                      _imagenActualUrl!.startsWith('http')
                                          ? _imagenActualUrl!
                                          : 'http://192.168.1.4:5000$_imagenActualUrl!',
                                    )
                                  : null) as ImageProvider?,
                          child: _nuevaImagen == null &&
                                  (_imagenActualUrl == null ||
                                      _imagenActualUrl!.isEmpty)
                              ? const Icon(
                                  Icons.camera_alt,
                                  color: Colors.pink,
                                  size: 50,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.pink,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Toca para cambiar la foto',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 25),

                  _CampoTexto(
                    controller: _nombreCtrl,
                    label: 'Nombre',
                    icon: Icons.person_outline,
                    enabled: !_guardando && !_eliminando,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'El nombre es requerido';
                      }
                      if (!RegExp(r"^[A-Za-zÁÉÍÓÚÑáéíóúñ\s]{2,}$").hasMatch(v)) {
                        return 'Solo letras y espacios';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),


                  _CampoTexto(
                    controller: _apellidoCtrl,
                    label: 'Apellido',
                    icon: Icons.badge_outlined,
                    enabled: !_guardando && !_eliminando,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'El apellido es requerido';
                      }
                      if (!RegExp(r"^[A-Za-zÁÉÍÓÚÑáéíóúñ\s]{2,}$").hasMatch(v)) {
                        return 'Solo letras y espacios';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),


                  _CampoTexto(
                    controller: _correoCtrl,
                    label: 'Correo',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !_guardando && !_eliminando,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'El correo es requerido';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(v)) {
                        return 'Correo inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),


                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _guardando || _eliminando
                              ? null
                              : () => Navigator.pop(context),
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
                          onPressed:
                              _guardando || _eliminando ? null : _guardar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: _guardando
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Guardar',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ✅ Divider
                  Divider(color: Colors.grey[400]),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _guardando || _eliminando
                          ? null
                          : _confirmarEliminar,
                      icon: _eliminando
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.delete_forever, color: Colors.white),
                      label: Text(
                        _eliminando ? 'Eliminando...' : 'Eliminar Cuenta',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Esta acción no se puede deshacer',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
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
  final bool enabled;
  final String? Function(String?)? validator;

  const _CampoTexto({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.enabled = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.pink),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.pink, width: 2),
        ),
      ),
      validator: validator,
    );
  }
}
