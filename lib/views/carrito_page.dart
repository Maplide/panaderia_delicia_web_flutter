import 'package:flutter/material.dart';
import 'package:panaderia_delicia_web/views/checkout_page.dart';
import 'package:panaderia_delicia_web/views/productos_page.dart';
import 'package:panaderia_delicia_web/widgets/sidebar_menu.dart';
import 'package:panaderia_delicia_web/widgets/social_buttons.dart';
import 'package:provider/provider.dart';
import 'package:panaderia_delicia_web/providers/carrito_provider.dart';

class CarritoPage extends StatelessWidget {
  const CarritoPage({super.key});

  String convertirEnlaceDriveADirecto(String enlaceDrive) {
    final regExp = RegExp(r'/d/([a-zA-Z0-9_-]+)');
    final match = regExp.firstMatch(enlaceDrive);
    if (match != null && match.groupCount >= 1) {
      final id = match.group(1);
      return 'https://drive.google.com/uc?export=view&id=$id';
    } else {
      return enlaceDrive;
    }
  }

  @override
  Widget build(BuildContext context) {
    final carritoProvider = Provider.of<CarritoProvider>(context);
    final carrito = carritoProvider.productos;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrito de Compras"),
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
        ],
      ),
      drawer: const SidebarMenu(),
      body: Column(
        children: [
          Expanded(
            child: carrito.isEmpty
                ? const Center(child: Text("Tu carrito está vacío"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    itemCount: carrito.length,
                    itemBuilder: (context, index) {
                      final producto = carrito[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  convertirEnlaceDriveADirecto(producto['imagen']),
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image, size: 40),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      producto['nombre'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "S/. ${producto['precio']} x ${producto['cantidad'] ?? 1}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: () => carritoProvider.disminuirCantidad(index),
                                    tooltip: "Disminuir",
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () => carritoProvider.aumentarCantidad(index),
                                    tooltip: "Aumentar",
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                                    onPressed: () => carritoProvider.eliminarProducto(index),
                                    tooltip: "Eliminar",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey, width: 0.4)),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                Text(
                  "Total: S/. ${carritoProvider.totalPrecio.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA64F1C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: carrito.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CheckoutPage(productos: carrito),
                              ),
                            );
                          },
                    icon: const Icon(Icons.shopping_bag),
                    label: const Text("Comprar"),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Síguenos en nuestras redes"),
                const SizedBox(height: 6),
                const SocialButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
