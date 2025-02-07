import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Scrollable privacy policy text
          const SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Last Updated: February 05, 2025',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '''
1. Introduction

Welcome to our Limited Edition Phones e-commerce application ("App"). This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our App. Please read this Privacy Policy carefully. By using the App, you consent to the practices described in this policy.

2. Information We Collect

2.1 Personal Information
We collect the following types of personal information:
• Name and contact information
• Email address
• Google account information (when you choose to sign in with Google)
• Profile photo
• Device gallery access (for profile photo uploads)
• Payment information
• Delivery address
• Device information and identifiers

2.2 Authentication Data
When you create an account, we collect:
• Email address and password (for email-based registration)
• Google account information (for Google Sign-In)

2.3 Payment Information
For transactions, we collect:
• Payment method selection (Razorpay or Cash on Delivery)
• Transaction history
• Billing information

Note: Credit card information is processed directly by Razorpay and is not stored on our servers.



11. Contact Us

If you have any questions about this Privacy Policy, please contact us at:

edicion@limitada.com
''',
                  style: TextStyle(fontSize: 16),
                ),
                // Add bottom padding to ensure the content isn't hidden behind the button
                SizedBox(height: 80),
              ],
            ),
          ),
          // Fixed position button at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, -2),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Add your logic here for accepting the privacy policy
                  Navigator.pop(context, true); // Return true to indicate acceptance
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Accept & Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}