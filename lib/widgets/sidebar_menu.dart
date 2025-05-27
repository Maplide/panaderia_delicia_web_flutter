import 'package:flutter/material.dart';
import 'package:panaderia_delicia_web/views/home_page.dart';
import 'package:panaderia_delicia_web/views/productos_page.dart';
import 'package:panaderia_delicia_web/views/pedidos_page.dart';
import 'package:panaderia_delicia_web/views/ubicacion_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:panaderia_delicia_web/views/login_page.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFFFF3E0), // color crema claro
      child: Column(
        children: [
          const SizedBox(height: 36),
          const CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white,
            child: Icon(Icons.bakery_dining, size: 32, color: Color(0xFFF21D44)),
          ),
          const SizedBox(height: 12),
          const Text(
            'Panadería Delicia',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFB71C1C),
            ),
          ),
          const SizedBox(height: 24),
          _buildMenuItem(
            context,
            icon: Icons.home,
            text: 'Inicio',
            page: const HomePage(),
          ),
          _buildMenuItem(
            context,
            icon: Icons.shopping_bag,
            text: 'Productos',
            page: const ProductosPage(),
          ),
          _buildMenuItem(
            context,
            icon: Icons.list_alt,
            text: 'Mis Pedidos',
            page: const PedidosPage(),
          ),
          _buildMenuItem(
            context,
            icon: Icons.map,
            text: 'Ubicación',
            page: const UbicacionPage(),
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings, color: Colors.black87),
            title: const Text('Administrar productos'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin-productos');
            },
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Cerrar sesión',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon, required String text, required Widget page}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(text),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
    );
  }
}
