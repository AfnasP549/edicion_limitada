// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edicion_limitada/common/utils/constatns/app_color.dart';
import 'package:edicion_limitada/features/address_management/view/address_manage_screen.dart';
import 'package:edicion_limitada/features/profile/model/profile_model.dart';
import 'package:edicion_limitada/features/profile/view/profile_screen.dart';
import 'package:edicion_limitada/screens/about_screen.dart';
import 'package:edicion_limitada/screens/privacy_policy_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edicion_limitada/features/auth/bloc/auth_bloc.dart';
import 'package:edicion_limitada/features/auth/views/service/auth_service.dart';
import 'package:edicion_limitada/features/auth/views/pages/login_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<AccountScreen> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthInitial) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Login()),
              (route) => false,
            );
          }
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildMenuItem(Icons.person, 'Profile', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              }),
              _buildMenuItem(Icons.location_on, 'Manage Address', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddressScreen()),
                );
              }),
              // _buildMenuItem(Icons.account_balance_wallet, 'Wallet', () {
              // //  _showWalletDetails(context);
              // }),
              // _buildMenuItem(Icons.report, 'Report', () {}),
              // _buildMenuItem(Icons.dark_mode, 'Switch Mode', () {}),
              _buildMenuItem(Icons.info, 'About', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutAppScreen()));
              }),
              _buildMenuItem(Icons.privacy_tip, 'Privacy Policy', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()));
              }),
              const Spacer(),
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFA3A3A3), Color(0xFF5B5B5B), Color(0xFF3D3D3D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildUserInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return StreamBuilder(
      stream: _auth.userStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data;
          return StreamBuilder<UserModel?>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user?.uid)
                .snapshots()
                .map((snapshot) => snapshot.exists
                    ? UserModel.fromMap(snapshot.data()!)
                    : null),
            builder: (context, profileSnapshot) {
              final userProfile = profileSnapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Heyy ${userProfile?.fullName ?? user?.displayName ?? ''} !',
                    style: TextStyle(
                      color: AppColor.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    'Explore our shopping section >>',
                    style: TextStyle(color: AppColor.primary, fontSize: 18),
                  )
                ],
              );
            },
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }

  

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFF2D0C0C),
          size: 24,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF2D0C0C),
            fontSize: 16,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Future<bool?> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        leading: const Icon(
          Icons.logout,
          color: Colors.red,
        ),
        title: const Text(
          'Logout',
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
          ),
        ),
        onTap: () async {
          final shouldLogout = await _showLogoutConfirmationDialog(context);
          if (shouldLogout == true) {
            context.read<AuthBloc>().add(Signout());
          }
        },
      ),
    );
  }
}