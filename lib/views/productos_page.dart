import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:panaderia_delicia_web/views/carrito_page.dart';
import 'package:panaderia_delicia_web/views/pedidos_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:panaderia_delicia_web/views/login_page.dart';
import 'package:panaderia_delicia_web/widgets/sidebar_menu.dart';
import 'package:panaderia_delicia_web/widgets/social_buttons.dart';
import 'package:provider/provider.dart';
import 'package:panaderia_delicia_web/providers/carrito_provider.dart';

class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  final List<String> categorias = [
    'Todos',
    'Panes',
    'Galletas',
    'Bizcochos',
    'Postres',
    'Pasteles',
    'Bocaditos',
  ];

  String categoriaSeleccionada = 'Todos';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Productos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: "Mis pedidos",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PedidosPage()),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                tooltip: "Carrito",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CarritoPage()),
                  );
                },
              ),
              if (carritoProvider.totalCantidad > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: CurvedAnimation(
                          parent: animation,
                          curve: Curves.elasticOut,
                        ),
                        child: child,
                      );
                    },
                    child: Container(
                      key: ValueKey<int>(carritoProvider.totalCantidad),
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${carritoProvider.totalCantidad}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
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
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: categorias.map((cat) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: categoriaSeleccionada == cat,
                    onSelected: (_) {
                      setState(() {
                        categoriaSeleccionada = cat;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('productos')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Error al cargar productos"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final productos = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  if (categoriaSeleccionada == 'Todos') return true;
                  return data['categoria'] == categoriaSeleccionada;
                }).toList();

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    final data = productos[index].data() as Map<String, dynamic>;
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.vertical(top: Radius.circular(16)),
                            child: AspectRatio(
                              aspectRatio: 1.5,
                              child: Image.network(
                                convertirEnlaceDriveADirecto(data['imagen']),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 60),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['nombre'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "S/. ${data['precio']}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFA64F1C),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF21D44),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      final producto = {
                                        'nombre': data['nombre'],
                                        'precio': data['precio'],
                                        'imagen': data['imagen'],
                                      };
                                      carritoProvider.agregarProducto(producto);

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('${data['nombre']} añadido al carrito'),
                                          duration: const Duration(milliseconds: 800),
                                        ),
                                      );
                                    },
                                    child: const Text("Agregar"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(),
          const Text(
            "Síguenos en nuestras redes",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const SocialButtons(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
