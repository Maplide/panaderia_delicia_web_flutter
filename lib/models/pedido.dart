class Pedido {
  final String uid;
  final List<Map<String, dynamic>> productos;
  final String tipoPago;
  final String tipoEntrega;
  final double total;
  final String estado;
  final DateTime fecha;

  Pedido({
    required this.uid,
    required this.productos,
    required this.tipoPago,
    required this.tipoEntrega,
    required this.total,
    required this.estado,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'productos': productos,
      'tipoPago': tipoPago,
      'tipoEntrega': tipoEntrega,
      'total': total,
      'estado': estado,
      'fecha': fecha,
    };
  }
}
