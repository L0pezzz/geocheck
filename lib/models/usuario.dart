class Usuario {
  final String uid;
  final String nombre;
  final String correo;
  final String rol; // 'Estudiante' o 'Docente'
  final String codigoMatricula;
  final String facultad;

  Usuario({
    required this.uid,
    required this.nombre,
    required this.correo,
    required this.rol,
    required this.codigoMatricula,
    required this.facultad,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nombre': nombre,
      'correo': correo,
      'rol': rol,
      'codigoMatricula': codigoMatricula,
      'facultad': facultad,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      uid: map['uid'] ?? '',
      nombre: map['nombre'] ?? '',
      correo: map['correo'] ?? '',
      rol: map['rol'] ?? 'Estudiante',
      codigoMatricula: map['codigoMatricula'] ?? '',
      facultad: map['facultad'] ?? '',
    );
  }
}