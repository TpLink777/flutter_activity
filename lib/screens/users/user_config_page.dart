// screens/settings/settings_page.dart
import 'package:flutter/material.dart';
import '../../models/cookieClient.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../users/user_edit_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Configuración',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.pink,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sección: Cuenta
          const Text(
            'CUENTA',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Editar Perfil
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.pink),
                  title: const Text('Editar Perfil'),
                  subtitle: const Text('Modifica tu información personal'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    if (!cookieClient.isAuthenticated) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Inicia sesión primero'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }


                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(color: Colors.pink),
                      ),
                    );

                    try {
                      final user = await UserService()
                          .getUserById(cookieClient.userId!);
                      
                      if (context.mounted) {
                        Navigator.pop(context); // Cierra loading

                        final resultado = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserEditPage(usuario: user),
                          ),
                        );

                        if (resultado == true && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Perfil actualizado'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        Navigator.pop(context); // Cierra loading
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                ),
                
                const Divider(height: 1),
                

                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.orange),
                  title: const Text('Cerrar Sesión'),
                  subtitle: const Text('Salir de tu cuenta'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Cerrar Sesión'),
                        content: const Text(
                          '¿Estás seguro de que quieres cerrar sesión?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                            onPressed: () {
                              cookieClient.logout();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/',
                                (route) => false,
                              );
                            },
                            child: const Text(
                              'Cerrar Sesión',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),      
        ],
      ),
    );
  }
}
