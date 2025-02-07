// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Column(
                children: [
                  Icon(
                    Icons.phone_iphone,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Limited Edition Phones',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle(title: 'About Us'),
                  const SectionContent(
                    content: 'Welcome to Limited Edition Phones - your premier destination '
                        'for exclusive and limited edition smartphone collections. We specialize '
                        'in bringing you unique and rare phone models that stand out from the crowd.',
                  ),
                  const SizedBox(height: 24),
                  
                  const SectionTitle(title: 'Key Features'),
                  const FeatureItem(
                    icon: Icons.phone_android,
                    title: 'Exclusive Collection',
                    description: 'Access to rare and limited edition phones not available elsewhere',
                  ),
                  const FeatureItem(
                    icon: Icons.payment,
                    title: 'Secure Payments',
                    description: 'Multiple payment options including Razorpay and Cash on Delivery',
                  ),
                  const FeatureItem(
                    icon: Icons.verified_user,
                    title: 'Authentic Products',
                    description: '100% genuine products with manufacturer warranty',
                  ),
                  const FeatureItem(
                    icon: Icons.local_shipping,
                    title: 'Fast Delivery',
                    description: 'Quick and secure delivery to your doorstep',
                  ),
                  
                  const SizedBox(height: 24),
                  const SectionTitle(title: 'Contact Us'),
                  const SectionContent(
                    content: 'Email: support@limitededitionphones.com\n'
                        'Phone: +1 234 567 8900\n'
                        'Address: Edicion Limitada',
                  ),
                  
                  const SizedBox(height: 24),
                  const SectionTitle(title: 'Follow Us'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildSocialButton(FontAwesomeIcons.facebook, () {}),
                      _buildSocialButton(FontAwesomeIcons.telegram, () {}),
                      _buildSocialButton(FontAwesomeIcons.instagram, () {}),
                      _buildSocialButton(FontAwesomeIcons.twitter, () {}),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      iconSize: 32,
      color: Colors.blue,
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class SectionContent extends StatelessWidget {
  final String content;

  const SectionContent({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 16,
        height: 1.5,
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 24,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}