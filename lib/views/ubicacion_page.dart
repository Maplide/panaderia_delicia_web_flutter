import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:panaderia_delicia_web/widgets/sidebar_menu.dart';

class UbicacionPage extends StatefulWidget {
  const UbicacionPage({super.key});

  @override
  State<UbicacionPage> createState() => _UbicacionPageState();
}

class _UbicacionPageState extends State<UbicacionPage> {
  GoogleMapController? mapController;
  LatLng ubicacionActual = const LatLng(-12.0651, -75.2049); // Huancayo

  @override
  void initState() {
    super.initState();
    obtenerUbicacion();
  }

  Future<void> obtenerUbicacion() async {
    LocationPermission permiso = await Geolocator.requestPermission();
    if (permiso == LocationPermission.deniedForever ||
        permiso == LocationPermission.denied) return;

    Position posicion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      ubicacionActual = LatLng(posicion.latitude, posicion.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ubicación')),
      drawer: const SidebarMenu(),
      body: GoogleMap(
        onMapCreated: (controller) => mapController = controller,
        initialCameraPosition: CameraPosition(
          target: ubicacionActual,
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('mi_ubicacion'),
            position: ubicacionActual,
            infoWindow: const InfoWindow(title: 'Estoy aquí'),
          ),
        },
      ),
    );
  }
}
