import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

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
              'About Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'HERLIFE is a dedicated mobile emergency system application focused on promoting safety, connection, and empowerment among women. It was developed to address the serious concern of harassment, violence, and unsafe environments that women face, especially in the context of Filipino women\'s specific needs.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              'What is HERLIFE?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'The app aims to provide discreet, reliable, and accessible features because traditional methods of seeking help are often insufficient or may expose women to further danger. While some mobile apps offer SOS features, most are developed abroad and fail to meet local needs.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              'Why was HERLIFE created?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'It was created to address local women\'s safety concerns and to offer a reliable emergency system tailored to Filipino women.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              'What are its core safety features?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'HERLIFE empowers users to quickly and quietly reach out for help using these key system features:',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              '• Discreet Alert / Shake-to-Alert: Allows users to quickly send an alert to trusted contacts, either by tapping the SOS button or shaking the phone twice. Alerts are sent silently in the background.\n\n'
              '• Real-time Location: Provides instant alerts to trusted contacts and authorities, including real-time location tracking and last known location access.\n\n'
              '• Community Awareness: Supports unsafe area reporting to promote collective vigilance and inform others about high-risk locations.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              'Our Commitment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'We prioritize building user trust by ensuring the system is:\n\n'
              '• Private and Secure: Incorporating strong data protection protocols to safeguard sensitive safety data and user identity.\n\n'
              '• Simple and Accessible: Designed with a user-friendly interface that does not require advanced technical skills.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
