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
    final size = MediaQuery.of(context).size;

    return Scaffold(
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
        child: Center(
          child: Container(
            width: size.width * 0.95,
            margin: const EdgeInsets.symmetric(vertical: 40),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF2CDA0), // Beige claro
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;
                return isMobile
                    ? Column(
                        children: [
                          _imageBanner(),
                          const SizedBox(height: 20),
                          _infoSection(context),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(flex: 1, child: _imageBanner()),
                          const SizedBox(width: 24),
                          Expanded(flex: 1, child: _infoSection(context)),
                        ],
                      );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Divider(),
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

  // Widget de imagen banner horizontal
  Widget _imageBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        'assets/images/panaderia_hero.jpeg',
        fit: BoxFit.cover,
        height: 250,
        width: double.infinity,
      ),
    );
  }

  // Widget de información y botón
  Widget _infoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "¡Bienvenidos a Panadería Delicia!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFA64F1C), // Marrón rojizo
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "Somos una panadería artesanal ubicada en el corazón de Huancayo, con más de 15 años ofreciendo los mejores sabores tradicionales. ",
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        const Text(
          "Ofrecemos panes, croissants, pasteles, tortas, empanadas y mucho más, elaborados diariamente con insumos frescos y naturales.",
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        const Text(
          "¡Y lo mejor! Puedes hacer tus pedidos con entrega a domicilio.",
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 24),

        // Botón centrado
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA64F1C), // Marrón rojizo
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProductosPage()),
              );
            },
            child: const Text(
              "Ver productos",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
