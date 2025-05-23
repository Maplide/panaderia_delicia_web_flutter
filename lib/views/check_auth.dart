import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:panaderia_delicia_web/views/login_page.dart';
import 'package:panaderia_delicia_web/views/home_page.dart';
import 'package:panaderia_delicia_web/views/admin_productos_page.dart';

class CheckAuth extends StatelessWidget {
  const CheckAuth({super.key});

  Future<String?> obtenerRol(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
      if (doc.exists) {
        return doc.data()?['rol'];
      }
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          return const LoginPage();
        }

        final uid = snapshot.data!.uid;

        return FutureBuilder<String?>(
          future: obtenerRol(uid),
          builder: (context, rolSnapshot) {
            if (rolSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (rolSnapshot.data == 'admin') {
              return const AdminProductosPage();
            } else {
              return const HomePage();
            }
          },
        );
      },
    );
  }
}
