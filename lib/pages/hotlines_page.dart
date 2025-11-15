import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HotlinesPage extends StatelessWidget {
  const HotlinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),   
              onPressed: () => context.go('/home'),
            ),
            const SizedBox(width: 8),
            const Text(
              'Hotline',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text('National Emergency Hotline'),
            subtitle: Text('911'),
          ),
          ListTile(
            title: Text('Philippine National Police'),
            subtitle: Text('117'),
          ),
          ListTile(
            title: Text('Bureau of Fire Protection'),
            subtitle: Text('117'),
          ),
          ListTile(
            title: Text('National Disaster Risk Reduction and Management Council'),
            subtitle: Text('(02) 8911-5061 to 65'),
          ),
        ],
      ),
    );
  }
}
