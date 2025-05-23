import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:panaderia_delicia_web/services/pedido_service.dart';
import 'package:panaderia_delicia_web/widgets/sidebar_menu.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> productos;

  const CheckoutPage({super.key, required this.productos});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String tipoPago = 'Efectivo';
  String tipoEntrega = 'Recojo en tienda';
  bool cargando = false;

  final opcionesPago = ['Efectivo', 'Yape', 'Plin', 'Tarjeta'];
  final opcionesEntrega = ['Recojo en tienda', 'Delivery'];

  double calcularTotal() {
    return widget.productos.fold(
      0.0,
      (total, item) => total + (item['precio'] * (item['cantidad'] ?? 1)),
    );
  }

  void confirmarPedido() async {
    setState(() => cargando = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Debes iniciar sesión.")),
        );
        return;
      }

      await PedidoService.guardarPedido(
        uid: user.uid,
        productos: widget.productos,
        tipoPago: tipoPago,
        tipoEntrega: tipoEntrega,
        total: calcularTotal(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pedido registrado con éxito")),
      );

      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al guardar: $e")),
      );
    } finally {
      setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirmar Pedido")),
      drawer: const SidebarMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: tipoPago,
              decoration: const InputDecoration(labelText: "Tipo de pago"),
              items: opcionesPago
                  .map((op) => DropdownMenuItem(value: op, child: Text(op)))
                  .toList(),
              onChanged: (value) => setState(() => tipoPago = value!),
            ),
            DropdownButtonFormField<String>(
              value: tipoEntrega,
              decoration: const InputDecoration(labelText: "Tipo de entrega"),
              items: opcionesEntrega
                  .map((op) => DropdownMenuItem(value: op, child: Text(op)))
                  .toList(),
              onChanged: (value) => setState(() => tipoEntrega = value!),
            ),
            const SizedBox(height: 20),
            Text("Total: S/. ${calcularTotal().toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            cargando
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: confirmarPedido,
                    child: const Text("Confirmar Pedido"),
                  ),
          ],
        ),
      ),
    );
  }
}
