// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:edicion_limitada/common/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edicion_limitada/features/auth/bloc/auth_bloc.dart';
import 'package:edicion_limitada/features/auth/views/service/auth_service.dart';
import 'package:edicion_limitada/features/auth/views/pages/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<ProfileScreen> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //  backgroundColor: const Color.fromARGB(255, 63, 62, 61),
      appBar: AppBar(
     //   backgroundColor: Color(0xFF06B6D4),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Heyy'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final shouldLogout = await _showLogoutConfirmationDialog(context);
              if (shouldLogout == true) {
                context.read<AuthBloc>().add(Signout());
              }
            },
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthInitial) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Login()),
              (route) => false,
            );
          }
        },
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 140,
                 // height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                        color: AppColor.GreyShade,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(60),
                          bottomRight: Radius.circular(60),
                        )
                  ),
                  child: Text('Profile',style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40
                  ),),
                ),
                Positioned(
                  bottom: -150,
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Column(children: [
                      // Container(
                      //   padding: EdgeInsets.all(3),
                      //   decoration: BoxDecoration(
                      //   color: Colors.white,
                      //   shape: BoxShape.circle,
                      //   border: Border.all(color: Colors.white, width: 2),
                      //   ),
                      //   child: const CircleAvatar(
                      //     radius: 80,
                      //     backgroundColor: Colors.black,
                      //     child: Icon(Icons.person, size: 100, color: Colors.white,),
                      //   ),
                      // ),
                       SizedBox(height: 16),

                       StreamBuilder(
                        stream: _auth.userStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final user = snapshot.data;
                            return Column(
                              children: [
                                Text(
                                  user?.displayName ?? '',
                                  style:TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 30,
                                  )
                                  // Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user?.email ?? '',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                  ),
                                ),
                              ],
                            );
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                    ],),
                  ),
                )
              ],
            ),
          ],
        ),
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
}
