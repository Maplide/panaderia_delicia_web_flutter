import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        _buildSocialIcon(
          icon: FontAwesomeIcons.facebookF,
          color: Colors.blue[800],
          tooltip: 'Facebook',
          url: 'https://www.facebook.com/PanaderiaDelicia',
        ),
        const SizedBox(width: 12),
        _buildSocialIcon(
          icon: FontAwesomeIcons.whatsapp,
          color: Colors.green[700],
          tooltip: 'WhatsApp',
          url: 'https://wa.me/51987654321',
        ),
        const SizedBox(width: 12),
        _buildSocialIcon(
          icon: FontAwesomeIcons.instagram,
          color: Colors.purple[400],
          tooltip: 'Instagram',
          url: 'https://www.instagram.com/PanaderiaDelicia',
        ),
      ],
    );
  }

  Widget _buildSocialIcon({
    required IconData icon,
    required Color? color,
    required String tooltip,
    required String url,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: () => _launchUrl(url),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: color!.withOpacity(0.1),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
