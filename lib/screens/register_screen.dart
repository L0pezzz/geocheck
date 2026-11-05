import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const Color colorPrimario = Color(0xFF0A192F);

  String _rolSeleccionado = 'Estudiante';
  String? _facultadSeleccionada;
  bool _aceptoTerminos = false;
  bool _mostrarContrasena = false;
  bool _mostrarConfirmarContrasena = false;
  bool _cargando = false;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _confirmarContrasenaController =
      TextEditingController();

  final List<String> _facultades = [
    'Ingeniería y Ciencias Básicas',
    'Ciencias de la Salud',
    'Educación y Ciencias Sociales',
    'Economía y Administración',
    'Derecho y Ciencias Políticas',
  ];

  // Requisitos dinámicos de la contraseña
  bool get _tiene8Caracteres => _contrasenaController.text.length >= 8;
  bool get _tieneMayuscula =>
      _contrasenaController.text.contains(RegExp(r'[A-Z]'));
  bool get _tieneNumero =>
      _contrasenaController.text.contains(RegExp(r'[0-9]'));

  void _registrar() async {
    final nombre = _nombreController.text.trim();
    final correo = _correoController.text.trim();
    final codigo = _codigoController.text.trim();
    final contrasena = _contrasenaController.text.trim();
    final confirmarContrasena = _confirmarContrasenaController.text.trim();

    if (nombre.isEmpty ||
        correo.isEmpty ||
        codigo.isEmpty ||
        contrasena.isEmpty) {
      _mostrarSnackBar(
        'Por favor completa todos los campos requeridos.',
        Colors.orange,
      );
      return;
    }

    if (_facultadSeleccionada == null) {
      _mostrarSnackBar(
        'Por favor selecciona tu Facultad o Departamento.',
        Colors.orange,
      );
      return;
    }

    if (!_tiene8Caracteres || !_tieneMayuscula || !_tieneNumero) {
      _mostrarSnackBar(
        'La contraseña no cumple con los requisitos de seguridad.',
        Colors.red,
      );
      return;
    }

    if (contrasena != confirmarContrasena) {
      _mostrarSnackBar('Las contraseñas no coinciden.', Colors.red);
      return;
    }

    if (!_aceptoTerminos) {
      _mostrarSnackBar(
        'Debes aceptar los términos y la telemetría académica.',
        Colors.orange,
      );
      return;
    }

    setState(() => _cargando = true);

    String? error = await AuthService.registrarUsuario(
      nombre: nombre,
      correo: correo,
      contrasena: contrasena,
      rol: _rolSeleccionado,
      codigoMatricula: codigo,
      facultad: _facultadSeleccionada!,
    );

    setState(() => _cargando = false);

    if (error == null && mounted) {
      _mostrarSnackBar(
        '¡Cuenta registrada con éxito en Firebase!',
        Colors.green,
      );
      Navigator.pop(context); // Regresa a la pantalla de Inicio de Sesión
    } else if (mounted) {
      _mostrarSnackBar(error ?? 'Error al registrar la cuenta.', Colors.red);
    }
  }

  void _mostrarSnackBar(String texto, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(texto), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 140,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back_ios_new, size: 12, color: colorPrimario),
                SizedBox(width: 4),
                Text(
                  'Volver al acceso',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: colorPrimario,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFD1FAE5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.circle, size: 8, color: Colors.green),
                SizedBox(width: 6),
                Text(
                  'Enlace Seguro',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Crear Nueva Cuenta',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorPrimario,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Ingresa tus credenciales institucionales para vincularte al sistema de asistencia inteligente GeoCheck.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 20),

              // 1. Selección de Rol
              const Text(
                'Selecciona tu Rol Académico',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: colorPrimario,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _rolSeleccionado = 'Estudiante'),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _rolSeleccionado == 'Estudiante'
                              ? colorPrimario
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _rolSeleccionado == 'Estudiante'
                                ? colorPrimario
                                : Colors.grey[300]!,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: _rolSeleccionado == 'Estudiante'
                                        ? Colors.white24
                                        : const Color(0xFFEEF2FF),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.school,
                                    color: _rolSeleccionado == 'Estudiante'
                                        ? Colors.white
                                        : colorPrimario,
                                    size: 18,
                                  ),
                                ),
                                Icon(
                                  _rolSeleccionado == 'Estudiante'
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color: _rolSeleccionado == 'Estudiante'
                                      ? Colors.tealAccent
                                      : Colors.grey[400],
                                  size: 18,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Estudiante',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: _rolSeleccionado == 'Estudiante'
                                    ? Colors.white
                                    : colorPrimario,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Registro de presencia automática vía GPS.',
                              style: TextStyle(
                                fontSize: 10,
                                color: _rolSeleccionado == 'Estudiante'
                                    ? Colors.white70
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _rolSeleccionado = 'Docente'),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _rolSeleccionado == 'Docente'
                              ? colorPrimario
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _rolSeleccionado == 'Docente'
                                ? colorPrimario
                                : Colors.grey[300]!,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: _rolSeleccionado == 'Docente'
                                        ? Colors.white24
                                        : const Color(0xFFEEF2FF),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.assignment_ind,
                                    color: _rolSeleccionado == 'Docente'
                                        ? Colors.white
                                        : colorPrimario,
                                    size: 18,
                                  ),
                                ),
                                Icon(
                                  _rolSeleccionado == 'Docente'
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color: _rolSeleccionado == 'Docente'
                                      ? Colors.tealAccent
                                      : Colors.grey[400],
                                  size: 18,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Docente',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: _rolSeleccionado == 'Docente'
                                    ? Colors.white
                                    : colorPrimario,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Gestión de aulas y auditoría en vivo.',
                              style: TextStyle(
                                fontSize: 10,
                                color: _rolSeleccionado == 'Docente'
                                    ? Colors.white70
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 2. Nombre Completo
              const Text(
                'Nombre Completo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: colorPrimario,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(
                  hintText: 'Ej. Camila Suárez o Carlos Martínez',
                  prefixIcon: const Icon(Icons.person_outline),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // 3. Correo Institucional
              const Text(
                'Correo Institucional',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: colorPrimario,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _correoController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'usuario@universidad.edu',
                  prefixIcon: const Icon(Icons.alternate_email),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.info_outline, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Solo correos autorizados con dominio .edu',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 4. Código o Matrícula
              const Text(
                'Código o Matrícula',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: colorPrimario,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _codigoController,
                decoration: InputDecoration(
                  hintText: 'EST-202410',
                  prefixIcon: const Icon(Icons.badge_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Código asignado por Registro y Control.',
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
              const SizedBox(height: 14),

              // 5. Facultad
              const Text(
                'Facultad o Departamento',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: colorPrimario,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _facultadSeleccionada,
                    hint: const Row(
                      children: [
                        Icon(
                          Icons.business_outlined,
                          color: Colors.grey,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Selecciona tu facultad...',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                    isExpanded: true,
                    items: _facultades.map((f) {
                      return DropdownMenuItem(
                        value: f,
                        child: Text(
                          f,
                          style: const TextStyle(
                            fontSize: 13,
                            color: colorPrimario,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) =>
                        setState(() => _facultadSeleccionada = val),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // 6. Contraseña
              const Text(
                'Contraseña',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: colorPrimario,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _contrasenaController,
                obscureText: !_mostrarContrasena,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Mínimo 8 caracteres',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _mostrarContrasena
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () => setState(
                      () => _mostrarContrasena = !_mostrarContrasena,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Requisitos
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F3F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _requisitoItem('Al menos 8 caracteres', _tiene8Caracteres),
                    const SizedBox(height: 4),
                    _requisitoItem(
                      'Al menos una letra mayúscula',
                      _tieneMayuscula,
                    ),
                    const SizedBox(height: 4),
                    _requisitoItem('Al menos un número', _tieneNumero),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 7. Confirmar Contraseña
              const Text(
                'Confirmar Contraseña',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: colorPrimario,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _confirmarContrasenaController,
                obscureText: !_mostrarConfirmarContrasena,
                decoration: InputDecoration(
                  hintText: 'Repite tu contraseña',
                  prefixIcon: const Icon(Icons.lock_reset_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _mostrarConfirmarContrasena
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () => setState(
                      () => _mostrarConfirmarContrasena =
                          !_mostrarConfirmarContrasena,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 8. Términos
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _aceptoTerminos,
                        activeColor: colorPrimario,
                        onChanged: (val) =>
                            setState(() => _aceptoTerminos = val ?? false),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Acepto la telemetría académica de ubicación GPS y cámara únicamente durante los horarios activos de clase.',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[800],
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 9. Botón Registrar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrimario,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _cargando ? null : _registrar,
                  icon: _cargando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.person_add_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                  label: Text(
                    _cargando ? '' : 'Registrar Cuenta',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 10. Volver a Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿Ya tienes una cuenta institucional? ',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colorPrimario,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _requisitoItem(String texto, bool cumplido) {
    return Row(
      children: [
        Icon(
          cumplido ? Icons.check_circle : Icons.check_circle_outline,
          size: 14,
          color: cumplido ? Colors.teal : Colors.grey,
        ),
        const SizedBox(width: 6),
        Text(
          texto,
          style: TextStyle(
            fontSize: 11,
            color: cumplido ? Colors.teal : Colors.grey[700],
            fontWeight: cumplido ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}