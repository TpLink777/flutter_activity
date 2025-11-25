import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import './user_detail_page.dart';

class UsersListPage extends StatefulWidget {
  const UsersListPage({super.key});

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  final UserService _service = UserService();

  List<dynamic> _usuarios = [];
  List<dynamic> _filteredUsuarios = [];
  bool _isLoading = true;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchUsuarios();
  }

  Future<void> _fetchUsuarios() async {
    setState(() => _isLoading = true);

    try {
      final users = await _service.getUsers();

      setState(() {
        _usuarios = users;
        _filteredUsuarios = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e', style: TextStyle(color: Colors.red)),
          ),
        );
      }
    }
  }

  void _buscarUsuario(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredUsuarios = _usuarios.where((u) {
        return u['nombre'].toString().toLowerCase().contains(_searchQuery) ||
            u['apellido'].toString().toLowerCase().contains(_searchQuery);
      }).toList();
    });
  }

  void _updateLocalUser(Map<String, dynamic> updated) {
    setState(() {
      final index = _usuarios.indexWhere((u) => u['id'] == updated['id']);
      if (index != -1) {
        _usuarios[index] = {..._usuarios[index], ...updated};
      }
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
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.pink))
          : Column(
              children: [
                if (_usuarios.length >= 6)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar usuario...',
                        hintStyle: const TextStyle(color: Colors.black),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.pink,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.pink[200]!),
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
                              radius: 25,
                              backgroundColor: Colors.white,
                              child:
                                  usuario['image_url'] != null &&
                                      usuario['image_url'].isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.network(
                                        usuario['image_url'],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person,
                                      color: Colors.pink,
                                      size: 30,
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
