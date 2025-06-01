import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:panaderia_delicia_web/views/register_page.dart';
import 'package:panaderia_delicia_web/views/check_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool cargando = false;

  void login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => cargando = true);

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const CheckAuth()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String mensaje;
        switch (e.code) {
          case 'user-not-found':
            mensaje = 'El correo ingresado no está registrado.';
            break;
          case 'wrong-password':
            mensaje = 'La contraseña es incorrecta.';
            break;
          case 'invalid-email':
            mensaje = 'El formato del correo es inválido.';
            break;
          default:
            mensaje = 'Error al iniciar sesión. Verifica tus credenciales.';
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(mensaje)),
          );
        }
      } finally {
        if (mounted) setState(() => cargando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_outline, size: 60, color: Color(0xFFF21D44)),
                  const SizedBox(height: 20),
                  Text(
                    "Bienvenido",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFF21D44),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Inicia sesión para continuar",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 25),

                  // EMAIL
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Correo electrónico",
                      prefixIcon: const Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Ingresa tu correo' : null,
                  ),

                  const SizedBox(height: 16),

                  // CONTRASEÑA
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      prefixIcon: const Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) =>
                        value == null || value.length < 6 ? 'Mínimo 6 caracteres' : null,
                  ),

                  const SizedBox(height: 25),

                  // BOTÓN LOGIN
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: cargando ? null : login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA64F1C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: cargando
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Ingresar"),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // TEXTO REGISTRO
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFF21B07),
                    ),
                    child: const Text("¿No tienes cuenta? Regístrate"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
