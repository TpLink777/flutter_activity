class UserModel {
  final int id;
  final String nombre;
  final String apellido;
  final String correo;
  final String? imageUrl;

  UserModel({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.correo,
    this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      correo: json['correo'],
      imageUrl: json['image'],
    );
  }
}
