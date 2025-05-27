import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:panaderia_delicia_web/widgets/sidebar_menu.dart';

class AdminProductosPage extends StatefulWidget {
  const AdminProductosPage({super.key});

  @override
  State<AdminProductosPage> createState() => _AdminProductosPageState();
}

class _AdminProductosPageState extends State<AdminProductosPage> {
  bool? permitido;

  @override
  void initState() {
    super.initState();
    verificarAcceso();
  }

  Future<void> verificarAcceso() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() => permitido = false);
      return;
    }

    final doc = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
    final rol = doc.data()?['rol'];

    setState(() {
      permitido = rol == 'admin';
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

  void eliminarProducto(String id) {
    FirebaseFirestore.instance.collection('productos').doc(id).delete();
  }

  void agregarProducto() {
    final nombreController = TextEditingController();
    final precioController = TextEditingController();
    final imagenController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Agregar Producto"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: "Nombre",
                  prefixIcon: Icon(Icons.text_fields),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: precioController,
                decoration: const InputDecoration(
                  labelText: "Precio",
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: imagenController,
                decoration: const InputDecoration(
                  labelText: "URL de imagen (Drive o directa)",
                  prefixIcon: Icon(Icons.image),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                final nombre = nombreController.text.trim();
                final precio = double.tryParse(precioController.text.trim()) ?? 0.0;
                final imagen = imagenController.text.trim();

                if (nombre.isEmpty || precio <= 0 || imagen.isEmpty) return;

                await FirebaseFirestore.instance.collection('productos').add({
                  'nombre': nombre,
                  'precio': precio,
                  'imagen': imagen,
                });

                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (permitido == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!permitido!) {
      return const Scaffold(
        body: Center(
          child: Text(
            "⛔ Acceso denegado. Solo administradores.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Gestión de Productos")),
      drawer: const SidebarMenu(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('productos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error al cargar productos"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final productos = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: productos.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final data = productos[index].data() as Map<String, dynamic>;
              final id = productos[index].id;

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    convertirEnlaceDriveADirecto(data['imagen']),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 40),
                  ),
                ),
                title: Text(
                  data['nombre'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text("S/. ${data['precio']}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Eliminar',
                  onPressed: () => eliminarProducto(id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: agregarProducto,
        backgroundColor: const Color(0xFFA64F1C),
        tooltip: 'Agregar producto',
        child: const Icon(Icons.add),
      ),
    );
  }
}
