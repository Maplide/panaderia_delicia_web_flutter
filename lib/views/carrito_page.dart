import 'package:flutter/material.dart';
import 'package:panaderia_delicia_web/views/checkout_page.dart';
import 'package:panaderia_delicia_web/views/productos_page.dart';
import 'package:panaderia_delicia_web/widgets/sidebar_menu.dart';
import 'package:panaderia_delicia_web/widgets/social_buttons.dart';

class CarritoPage extends StatefulWidget {
  final List<Map<String, dynamic>> productos;
  const CarritoPage({super.key, required this.productos});

  @override
  State<CarritoPage> createState() => _CarritoPageState();
}

class _CarritoPageState extends State<CarritoPage> {
  late List<Map<String, dynamic>> carrito;

  @override
  void initState() {
    super.initState();
    carrito = List<Map<String, dynamic>>.from(widget.productos);
  }

  double calcularTotal() {
    return carrito.fold(
      0.0,
      (total, p) => total + (p['precio'] * (p['cantidad'] ?? 1)),
    );
  }

  void aumentarCantidad(int index) {
    setState(() {
      carrito[index]['cantidad'] = (carrito[index]['cantidad'] ?? 1) + 1;
    });
  }

  void disminuirCantidad(int index) {
    setState(() {
      if ((carrito[index]['cantidad'] ?? 1) > 1) {
        carrito[index]['cantidad'] -= 1;
      }
    });
  }

  void eliminarProducto(int index) {
    setState(() {
      carrito.removeAt(index);
    });
  }

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
                    itemCount: carrito.length,
                    itemBuilder: (context, index) {
                      final producto = carrito[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        elevation: 2,
                        child: ListTile(
                          leading: Image.network(
                            convertirEnlaceDriveADirecto(producto['imagen']),
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
                          ),
                          title: Text(producto['nombre']),
                          subtitle: Text("S/. ${producto['precio']} x ${producto['cantidad'] ?? 1}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(icon: const Icon(Icons.remove), onPressed: () => disminuirCantidad(index)),
                              IconButton(icon: const Icon(Icons.add), onPressed: () => aumentarCantidad(index)),
                              IconButton(icon: const Icon(Icons.delete), onPressed: () => eliminarProducto(index)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(
                  "Total: S/. ${calcularTotal().toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
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
                const SizedBox(height: 20),
                const Center(child: Text("Síguenos en nuestras redes")),
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
