import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/usuario.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Registro de usuario en Firebase Auth y Firestore
  static Future<String?> registrarUsuario({
    required String nombre,
    required String correo,
    required String contrasena,
    required String rol,
    required String codigoMatricula,
    required String facultad,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: correo,
        password: contrasena,
      );

      final String uid = credential.user!.uid;

      Usuario nuevoUsuario = Usuario(
        uid: uid,
        nombre: nombre,
        correo: correo,
        rol: rol,
        codigoMatricula: codigoMatricula,
        facultad: facultad,
      );

      await _db.collection('usuarios').doc(uid).set(nuevoUsuario.toMap());

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'La contraseña es muy débil (mínimo 6 caracteres).';
      } else if (e.code == 'email-already-in-use') {
        return 'Este correo ya está registrado.';
      } else if (e.code == 'invalid-email') {
        return 'El formato del correo no es válido.';
      }
      return e.message ?? 'Error al registrar la cuenta.';
    } catch (e) {
      return 'Ocurrió un error inesperado al conectar con Firebase.';
    }
  }

  /// Inicio de Sesión
  static Future<Usuario?> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: correo,
        password: contrasena,
      );

      final String uid = credential.user!.uid;
      DocumentSnapshot doc = await _db.collection('usuarios').doc(uid).get();

      if (doc.exists) {
        return Usuario.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Verifica el formato del correo y la existencia de la cuenta en Firebase
  static Future<String?> verificarYRecuperarContrasena(String correo) async {
    // 1. Validación de formato de correo con Expresión Regular
    final bool correoValido = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
        .hasMatch(correo);

    if (!correoValido) {
      return 'Por favor ingresa un correo electrónico válido (ejemplo@universidad.edu).';
    }

    try {
      // 2. Enviar el correo de restablecimiento vía Firebase Auth
      await _auth.sendPasswordResetEmail(email: correo);
      return null; // Éxito
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No existe ninguna cuenta registrada con este correo institucional.';
      } else if (e.code == 'invalid-email') {
        return 'El formato del correo no es válido.';
      }
      return e.message ?? 'Error al procesar la solicitud de recuperación.';
    } catch (e) {
      return 'Ocurrió un error al verificar el correo en la base de datos.';
    }
  }

  /// Cerrar Sesión
  static Future<void> cerrarSesion() async {
    await _auth.signOut();
  }
}