import 'package:cloud_firestore/cloud_firestore.dart';

class PedidoService {
  static Future<void> guardarPedido({
    required String uid,
    required List<Map<String, dynamic>> productos,
    required String tipoPago,
    required String tipoEntrega,
    required double total,
  }) async {
    final pedido = {
      'uid': uid,
      'productos': productos,
      'tipoPago': tipoPago,
      'tipoEntrega': tipoEntrega,
      'total': total,
      'estado': 'pendiente',
      'fecha': Timestamp.now(),
    };

    await FirebaseFirestore.instance.collection('pedidos').add(pedido);
  }
}
