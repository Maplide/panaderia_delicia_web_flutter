import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:panaderia_delicia_web/views/carrito_page.dart';
import 'package:panaderia_delicia_web/views/login_page.dart';
import 'package:panaderia_delicia_web/views/productos_page.dart';
import 'package:panaderia_delicia_web/widgets/sidebar_menu.dart';
import 'package:panaderia_delicia_web/widgets/social_buttons.dart';

class PedidosPage extends StatelessWidget {
  const PedidosPage({super.key});

  Stream<QuerySnapshot> obtenerPedidosDelUsuario() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('pedidos')
        .where('uid', isEqualTo: uid)
        .orderBy('fecha', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> carrito = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Pedidos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.store),
            tooltip: "Ver productos",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProductosPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            tooltip: "Carrito",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CarritoPage(productos: carrito),
                ),
              );
            },
          ),
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
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: obtenerPedidosDelUsuario(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Error al cargar pedidos"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final pedidos = snapshot.data!.docs;

                if (pedidos.isEmpty) {
                  return const Center(child: Text("No tienes pedidos aún."));
                }

                return ListView.builder(
                  itemCount: pedidos.length,
                  itemBuilder: (context, index) {
                    final pedido = pedidos[index].data() as Map<String, dynamic>;
                    final productos = List<Map<String, dynamic>>.from(pedido['productos']);
                    final fecha = (pedido['fecha'] as Timestamp).toDate();

                    return Card(
                      margin: const EdgeInsets.all(12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Fecha: ${fecha.toLocal()}",
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text("Tipo de entrega: ${pedido['tipoEntrega']}"),
                            Text("Tipo de pago: ${pedido['tipoPago']}"),
                            Text("Estado: ${pedido['estado']}"),
                            Text("Total: S/. ${pedido['total'].toStringAsFixed(2)}"),
                            const SizedBox(height: 8),
                            const Text("Productos:", style: TextStyle(fontWeight: FontWeight.bold)),
                            ...productos.map((p) => Text("- ${p['nombre']} x${p['cantidad']}")),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          const Center(child: Text("Síguenos en nuestras redes")),
          const SizedBox(height: 6),
          const SocialButtons(),
        ],
      ),
    );
  }
}
