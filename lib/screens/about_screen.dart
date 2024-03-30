import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('About Memora'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'lib/assets/images/mApp.png',
                width: 150,
                height: 150,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Memora',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Memora is your personal photo diary app to capture and cherish your memorable moments.',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Features:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            ..._buildFeatureList(), // Spread operator for cleaner list building
            const SizedBox(height: 20.0),
            const Text(
              'Our Mission:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'At Memora, we strive to provide you with a simple yet powerful tool to preserve your life\'s most meaningful moments. Our mission is to help you create a digital legacy filled with memories that you can cherish forever.',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Thank you for choosing Memora to preserve your precious memories!',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFeatureList() {
    return const [
      FeatureItem(title: 'Capture Moments', description: 'Document your special days with photos, notes, and details.'),
      FeatureItem(title: 'Self Journaling', description: 'Reflect on your experiences and thoughts by journaling your day.'),
      FeatureItem(title: 'Save Memories', description: 'Store your precious memories securely within the app for easy access anytime, anywhere.'),
    ];
  }
}

class FeatureItem extends StatelessWidget {
  final String title;
  final String description;

  const FeatureItem({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5.0),
          Text(
            description,
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
