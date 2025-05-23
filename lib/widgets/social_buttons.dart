import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.facebook, color: Colors.blue),
          onPressed: () => _launchUrl('https://www.facebook.com/PanaderiaDelicia'),
        ),
        IconButton(
          icon: const Icon(Icons.message, color: Colors.green),
          onPressed: () => _launchUrl('https://wa.me/51987654321'),
        ),
        IconButton(
          icon: const Icon(Icons.language, color: Colors.purple),
          onPressed: () => _launchUrl('https://www.instagram.com/PanaderiaDelicia'),
        ),
      ],
    );
  }
}
