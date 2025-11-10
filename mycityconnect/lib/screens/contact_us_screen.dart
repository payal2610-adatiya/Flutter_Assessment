import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    const phone = '+911234567890';
    const website = 'https://www.example.com';
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(onPressed: () async {
              final uri = Uri.parse('tel:$phone');
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            }, child: const Text('Call')),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: () async {
              final uri = Uri.parse('sms:$phone?body=Hello');
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            }, child: const Text('SMS')),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: () async {
              final uri = Uri.parse(website);
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            }, child: const Text('Website')),
          ],
        ),
      ),
    );
  }
}
