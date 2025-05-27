import 'package:flutter/material.dart';

class CarritoProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _carrito = [];

  // Getter para obtener los productos del carrito
  List<Map<String, dynamic>> get productos => _carrito;

  // Cantidad total de productos (sumando cantidades)
  int get totalCantidad {
    return _carrito.fold<int>(
      0,
      (total, p) => total + ((p['cantidad'] ?? 1) as int),
    );
  }

  // Precio total del carrito
  double get totalPrecio {
    return _carrito.fold<double>(
      0,
      (total, p) => total + ((p['precio'] ?? 0.0) * (p['cantidad'] ?? 1)),
    );
  }

  // Agregar producto al carrito
  void agregarProducto(Map<String, dynamic> producto) {
    final index = _carrito.indexWhere((p) => p['nombre'] == producto['nombre']);
    if (index != -1) {
      _carrito[index]['cantidad'] += 1;
    } else {
      _carrito.add({...producto, 'cantidad': 1});
    }
    notifyListeners();
  }

  // Aumentar cantidad de un producto
  void aumentarCantidad(int index) {
    _carrito[index]['cantidad'] += 1;
    notifyListeners();
  }

  // Disminuir cantidad de un producto
  void disminuirCantidad(int index) {
    if (_carrito[index]['cantidad'] > 1) {
      _carrito[index]['cantidad'] -= 1;
      notifyListeners();
    }
  }

  // Eliminar producto por índice
  void eliminarProducto(int index) {
    _carrito.removeAt(index);
    notifyListeners();
  }

  // Vaciar todo el carrito
  void limpiarCarrito() {
    _carrito.clear();
    notifyListeners();
  }
}
