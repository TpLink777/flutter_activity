import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Android emulator usa 10.0.2.2 para localhost
// ip -> 192.168.1.10
const String baseUrl = 'http://10.0.2.2:5000/api/activity';

class ListViewUsers extends StatefulWidget {
  const ListViewUsers({super.key});

  @override
  State<ListViewUsers> createState() => _ListViewUsersState();
}

class _ListViewUsersState extends State<ListViewUsers> {
  List<dynamic> _usuarios = [];
  List<dynamic> _filteredUsuarios = [];
  bool _isLoading = true;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState(); // inicializador del estado en la pantalla
    _fetchUsuarios();
  }

  Future<void> _fetchUsuarios() async {
    // future significa que la función hará trabajo asíncrono y terminará en el futuro.
    setState(
      () => _isLoading = true,
    ); // Marca que comienza la carga, notifiacando que el estado cambió
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/findInformationData'))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        // Decodifica la respuesta JSON y la convierte en un Object['List','Map'] de Dart
        final data = json.decode(response.body);
        setState(() {
          _usuarios = data['data'] ?? data ?? [];
          _filteredUsuarios = _usuarios;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      // mounted es una propiedad que indica si el widget aún está activo en la pantalla.
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e', style: TextStyle(color: Colors.red)),
          ),
        );
    }
  }

  void _buscarUsuario(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredUsuarios = _usuarios
          .where(
            (u) =>
                u['nombre'].toString().toLowerCase().contains(_searchQuery) ||
                u['apellido'].toString().toLowerCase().contains(_searchQuery),
          )
          .toList();
    });
  }

  void _updateLocalUser(Map<String, dynamic> updated) {
    setState(() {
      final index = _usuarios.indexWhere((u) => u['id'] == updated['id']);
      if (index != -1) _usuarios[index] = {..._usuarios[index], ...updated};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      appBar: AppBar(
        title: const Text(
          'Lista de Usuarios',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.pink))
          : Column(
              children: [
                if (_usuarios.length >= 6)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      bottom: 0,
                      left: 20,
                      right: 20,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar usuario...',
                        hintStyle: TextStyle(color: Colors.black),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.pink,
                        ),
                        focusColor: Colors.pink,

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:  BorderSide(color: Colors.pink[200]!),
                        ),

                      ),
                      onChanged: _buscarUsuario,
                      cursorColor: Colors.pink,
                    ),
                  ),
                Expanded(
                  child: ListView.builder( 
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredUsuarios.length,
                    itemBuilder: (context, index) {
                      final usuario = _filteredUsuarios[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          elevation: 20,
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.pink[100],
                              child: const Icon(
                                Icons.person,
                                color: Colors.pink,
                              ),
                            ),
                            title: Text(
                              usuario['nombre']?.toString().toUpperCase() ??
                                  'DESCONOCIDO',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              usuario['apellido'] ?? 'Sin apellido',
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.pink,
                              size: 22,
                            ),
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DetalleUsuarioPage(usuario: usuario),
                                ),
                              );
                              if (result == true) {
                                _fetchUsuarios();
                              } else if (result is Map<String, dynamic>) {
                                _updateLocalUser(result);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class DetalleUsuarioPage extends StatelessWidget {
  final Map<String, dynamic> usuario;

  const DetalleUsuarioPage({required this.usuario, super.key});

  Future<bool> _eliminarUsuario(BuildContext context) async {
    final id = usuario['id'];
    if (id == null) return false;

    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/delete-information/$id'))
          .timeout(const Duration(seconds: 15));
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      if (context.mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      return false;
    }
  }

  void _confirmarEliminacion(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFFF5F7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Confirmar eliminación',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink),
          textAlign: TextAlign.center,
        ),
        content: const Text(
          '¿Desea eliminar este usuario?',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await _eliminarUsuario(context);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.black,
                    content: Text(
                      'Usuario eliminado Exitosamente!',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
                Navigator.pop(context, true);
              }
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = usuario['image_url'];
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          usuario['nombre']?.toString().toUpperCase() ?? 'DETALLE',
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF5F7),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 60,
                backgroundImage: imageUrl != null && imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : null,
                child: imageUrl == null || imageUrl.isEmpty
                    ? const Icon(Icons.person, size: 90, color: Colors.pink)
                    : null,
              ),
              const SizedBox(height: 20),
              Text(
                usuario['nombre']?.toString().toUpperCase() ?? 'DESCONOCIDO',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                usuario['apellido'] ?? 'No disponible',
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.email_outlined,
                      color: Color.fromARGB(255, 113, 113, 113), size: 20),
                  const SizedBox(width: 6),
                  Text(
                    usuario['correo'] ?? 'Sin correo',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BotonAccion(
                    icon: Icons.edit_outlined,
                    label: 'Editar',
                    color: Colors.purple,
                    onTap: () async {
                      final updated =
                          await Navigator.push<Map<String, dynamic>?>(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EditarUsuarioPage(usuario: usuario),
                        ),
                      );
                      if (updated != null && context.mounted) {
                        Navigator.pop(context, updated);
                      }
                    },
                  ),
                  _BotonAccion(
                    icon: Icons.delete_outline,
                    label: 'Eliminar',
                    color: Colors.redAccent,
                    onTap: () => _confirmarEliminacion(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _BotonAccion extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _BotonAccion({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // inkwell es un widget que detecta toques y muestra efectos visuales
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      splashColor: Colors.pink[300],
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditarUsuarioPage extends StatefulWidget {
  final Map<String, dynamic> usuario;
  const EditarUsuarioPage({required this.usuario, super.key});

  @override
  State<EditarUsuarioPage> createState() => _EditarUsuarioPageState();
}

class _EditarUsuarioPageState extends State<EditarUsuarioPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreCtrl, _apellidoCtrl, _correoCtrl;
  bool _guardando = false;

  // 🖼 Variables para manejar imagen
  File? _nuevaImagen; // imagen seleccionada
  String? _imagenActualUrl; // URL actual del usuario

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.usuario['nombre']);
    _apellidoCtrl = TextEditingController(text: widget.usuario['apellido']);
    _correoCtrl = TextEditingController(text: widget.usuario['correo']);
    _imagenActualUrl = widget.usuario['image_url']; // cargamos la imagen actual
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidoCtrl.dispose();
    _correoCtrl.dispose();
    super.dispose();
  }

  // 🧩 Método para abrir el selector de imágenes
  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // galería

    if (pickedFile != null) {
      setState(() {
        _nuevaImagen = File(pickedFile.path);
      });
    }
  }

  // 💾 Método para guardar datos e imagen
  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final id = widget.usuario['id'];
    if (id == null) return;

    setState(() => _guardando = true);

    try {
      // Si hay imagen nueva, usamos MultipartRequest
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/updated-information/$id'),
      );

      // Campos normales
      request.fields['nombre'] = _nombreCtrl.text.trim();
      request.fields['apellido'] = _apellidoCtrl.text.trim();
      request.fields['correo'] = _correoCtrl.text.trim();

      // Imagen (solo si el usuario seleccionó una nueva)
      if (_nuevaImagen != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image', // este nombre debe coincidir con el campo que tu backend espera
          _nuevaImagen!.path,
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = json.decode(response.body);
        final updated = decoded['data'] ??
            {
              'id': id,
              'nombre': _nombreCtrl.text.trim(),
              'apellido': _apellidoCtrl.text.trim(),
              'correo': _correoCtrl.text.trim(),
              'image_url': _imagenActualUrl,
            };

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuario actualizado exitosamente')),
          );
          Navigator.pop(context, updated);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.body}')),
          );
        }
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _guardando = false);
    }
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🖼 Imagen editable
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
                              : const Text('Guardar',
                                  style: TextStyle(color: Colors.white)),
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