import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/auth_screen.dart';

void main() async {
  // Asegura que las vinculaciones de Flutter estén inicializadas antes de Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase con las opciones de la plataforma
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const GeoCheckApp());
}

class GeoCheckApp extends StatelessWidget {
  const GeoCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GeoCheck Campus',
      theme: ThemeData(
        fontFamily: 'sans-serif',
        primaryColor: const Color(0xFF0A192F),
      ),
      home: const AuthScreen(),
    );
  }
}