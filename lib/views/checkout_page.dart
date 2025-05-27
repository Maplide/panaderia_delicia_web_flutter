import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:panaderia_delicia_web/services/pedido_service.dart';

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
    final total = calcularTotal();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(title: const Text("Confirmar Pedido")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.shopping_cart_checkout,
                    size: 50, color: Color(0xFFF21D44)),
                const SizedBox(height: 16),
                Text(
                  "Revisa tu pedido",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFF21D44),
                  ),
                ),
                const SizedBox(height: 20),

                // Tipo de pago
                DropdownButtonFormField<String>(
                  value: tipoPago,
                  decoration: InputDecoration(
                    labelText: "Tipo de pago",
                    prefixIcon: const Icon(Icons.payment),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: opcionesPago
                      .map((op) => DropdownMenuItem(value: op, child: Text(op)))
                      .toList(),
                  onChanged: (value) => setState(() => tipoPago = value!),
                ),

                const SizedBox(height: 16),

                // Tipo de entrega
                DropdownButtonFormField<String>(
                  value: tipoEntrega,
                  decoration: InputDecoration(
                    labelText: "Tipo de entrega",
                    prefixIcon: const Icon(Icons.local_shipping),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: opcionesEntrega
                      .map((op) => DropdownMenuItem(value: op, child: Text(op)))
                      .toList(),
                  onChanged: (value) => setState(() => tipoEntrega = value!),
                ),

                const SizedBox(height: 25),

                // Total
                Center(
                  child: Text(
                    "Total: S/. ${total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFA64F1C),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Botón confirmar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: cargando ? null : confirmarPedido,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA64F1C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: cargando
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Confirmar Pedido"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
