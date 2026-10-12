import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final correo = TextEditingController();
  final clave = TextEditingController();

  bool registrarse = false;
  bool procesando = false;

  @override
  void dispose() {
    correo.dispose();
    clave.dispose();
    super.dispose();
  }

  void mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  String mensajeError(String codigo) {
    switch (codigo) {
      case 'email-already-in-use':
        return 'Este correo ya está registrado.';
      case 'invalid-email':
        return 'El correo electrónico no es válido.';
      case 'weak-password':
        return 'La contraseña es demasiado débil.';
      case 'wrong-password':
      case 'user-not-found':
      case 'invalid-credential':
        return 'Correo o contraseña incorrectos.';
      default:
        return 'No se pudo completar la operación: $codigo';
    }
  }

  Future<void> ingresar() async {
    if (correo.text.trim().isEmpty || clave.text.isEmpty) {
      mostrarMensaje('Ingresa el correo y la contraseña.');
      return;
    }

    setState(() => procesando = true);

    try {
      if (registrarse) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: correo.text.trim(),
          password: clave.text,
        );
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: correo.text.trim(),
          password: clave.text,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) mostrarMensaje(mensajeError(e.code));
    } catch (e) {
      if (mounted) {
        mostrarMensaje('Ocurrió un error al conectar con Firebase.');
      }
    } finally {
      if (mounted) setState(() => procesando = false);
    }
  }

  Future<void> recuperarClave() async {
    if (correo.text.trim().isEmpty) {
      mostrarMensaje('Escribe primero tu correo electrónico.');
      return;
    }

    setState(() => procesando = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: correo.text.trim(),
      );

      if (mounted) {
        mostrarMensaje(
          'Si existe una cuenta asociada, recibirás instrucciones por correo.',
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) mostrarMensaje(mensajeError(e.code));
    } finally {
      if (mounted) setState(() => procesando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.devices, size: 65, color: Colors.blue),
                    const SizedBox(height: 12),
                    const Text(
                      'TecnoStore',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      registrarse ? 'Registro de clientes' : 'Iniciar sesión',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: correo,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: clave,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: procesando ? null : ingresar,
                        child: Text(
                          procesando
                              ? 'Procesando...'
                              : registrarse
                              ? 'Crear cuenta'
                              : 'Ingresar',
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: procesando
                          ? null
                          : () => setState(() => registrarse = !registrarse),
                      child: Text(
                        registrarse
                            ? 'Ya tengo una cuenta'
                            : 'Crear una cuenta nueva',
                      ),
                    ),
                    if (!registrarse)
                      TextButton(
                        onPressed: procesando ? null : recuperarClave,
                        child: const Text('Olvidé mi contraseña'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
