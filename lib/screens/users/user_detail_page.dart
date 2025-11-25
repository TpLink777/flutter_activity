import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import './user_edit_page.dart';

class DetalleUsuarioPage extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const DetalleUsuarioPage({
    required this.usuario,
    super.key,
  });

  @override
  State<DetalleUsuarioPage> createState() => _DetalleUsuarioPageState();
}

class _DetalleUsuarioPageState extends State<DetalleUsuarioPage> {
  final UserService _service = UserService();
  bool _eliminando = false;

  Future<bool> _eliminarUsuario(BuildContext context) async {
    if (_eliminando) return false;
    setState(() => _eliminando = true);

    final success = await _service.deleteUser(widget.usuario['id']);

    if (!mounted) return false;
    setState(() => _eliminando = false);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al eliminar usuario")),
      );
    }

    return success;
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
    final user = widget.usuario;
    final String? imageUrl = user['image_url'];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          user['nombre']?.toString().toUpperCase() ?? 'DETALLE',
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
                user['nombre']?.toString().toUpperCase() ?? 'DESCONOCIDO',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user['apellido'] ?? 'No disponible',
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
                    user['correo'] ?? 'Sin correo',
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
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UserEditPage(usuario: user),
                        ),
                      );

                      if (updated == true && context.mounted) {
                        Navigator.pop(context, true);
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
