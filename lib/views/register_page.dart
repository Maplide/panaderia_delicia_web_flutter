import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:panaderia_delicia_web/views/login_page.dart';
import 'package:panaderia_delicia_web/views/productos_page.dart';
import 'package:panaderia_delicia_web/widgets/sidebar_menu.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final adminKeyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool cargando = false;
  String selectedRol = 'cliente';

  void register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => cargando = true);

      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        final uid = credential.user!.uid;

        await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
          'correo': emailController.text.trim(),
          'rol': selectedRol,
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProductosPage()),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.message}")),
        );
      } finally {
        setState(() => cargando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro")),
      drawer: const SidebarMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Correo electrónico"),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingresa tu correo' : null,
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Contraseña"),
                obscureText: true,
                validator: (value) =>
                    value == null || value.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedRol,
                items: const [
                  DropdownMenuItem(value: 'cliente', child: Text('Cliente')),
                  DropdownMenuItem(value: 'admin', child: Text('Administrador')),
                ],
                onChanged: (value) {
                  setState(() => selectedRol = value!);
                },
                decoration: const InputDecoration(labelText: "Rol"),
              ),
              if (selectedRol == 'admin')
                TextFormField(
                  controller: adminKeyController,
                  decoration: const InputDecoration(labelText: "Clave de administrador"),
                  obscureText: true,
                  validator: (value) {
                    if (selectedRol == 'admin' && value != 'CLAVESEGURA123') {
                      return 'Clave incorrecta';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 16),
              cargando
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: register,
                      child: const Text("Registrarse"),
                    ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                child: const Text("¿Ya tienes cuenta? Inicia sesión"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
