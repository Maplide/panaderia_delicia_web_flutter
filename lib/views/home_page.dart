import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:panaderia_delicia_web/views/login_page.dart';
import 'package:panaderia_delicia_web/views/productos_page.dart';
import 'package:panaderia_delicia_web/widgets/sidebar_menu.dart';
import 'package:panaderia_delicia_web/widgets/social_buttons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Panadería Delicia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Cerrar sesión",
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      drawer: const SidebarMenu(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen principal panorámica
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Image.asset(
                'assets/images/panaderia_hero.jpg',
                height: 280,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 32),

            // Sección de bienvenida
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "¡Bienvenidos a Panadería Delicia!",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFA64F1C),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Somos una panadería artesanal ubicada en el corazón de Huancayo. Llevamos más de 15 años ofreciendo los mejores sabores tradicionales.",
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Disfruta de panes, croissants, tortas, empanadas y más. Elaborados a diario con insumos frescos y naturales.",
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "¡Y ahora puedes pedir desde la comodidad de tu casa!",
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 28),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA64F1C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProductosPage()),
                        );
                      },
                      child: const Text("Ver productos"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Divider(thickness: 1.2),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "Síguenos en nuestras redes",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SocialButtons(),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
