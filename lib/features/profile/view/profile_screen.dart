import 'dart:convert';

import 'package:edicion_limitada/common/utils/constatns/app_color.dart';
import 'package:edicion_limitada/features/auth/views/service/auth_service.dart';
import 'package:edicion_limitada/features/profile/model/profile_model.dart';
import 'package:edicion_limitada/features/profile/view/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:edicion_limitada/features/profile/bloc/profile_bloc.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final AuthService _auth = AuthService();

  Widget _buildInfoTile({
    required String title, 
    required String value, 
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColor.primary, size: 30),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: _auth.userStream,
          builder: (context, authSnapshot) {
            if (!authSnapshot.hasData) {
              context.read<ProfileBloc>().add(ResetProfile());
              return const Center(child: CircularProgressIndicator());
            }
            
            final user = authSnapshot.data;
            if (user == null) {
              return const Center(child: Text('No user found'));
            }

            context.read<ProfileBloc>().add(LoadProfile(user.uid));

            return BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (state is ProfileLoadedState) {
                  final userProfile = state.user;
                  
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profile Picture
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColor.primary,
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: userProfile.imageUrl != null
                                  ? ClipOval(
                                      child: Image.memory(
                                        base64Decode(userProfile.imageUrl!),
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return _defaultProfileIcon();
                                        },
                                      ),
                                    )
                                  : _defaultProfileIcon(),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Profile Name
                          Text(
                            userProfile.fullName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Profile Information Tiles
                          _buildInfoTile(
                            title: 'Email',
                            value: user.email ?? '',
                            icon: Icons.email_outlined,
                          ),

                          _buildInfoTile(
                            title: 'Phone Number',
                            value: userProfile.number == 0 
                              ? 'Not set' 
                              : userProfile.number.toString(),
                            icon: Icons.phone_outlined,
                          ),

                          _buildInfoTile(
                            title: 'Date of Birth',
                            value: userProfile.dob == 0
                              ? 'Not set'
                              : DateFormat('dd-MM-yyyy').format(
                                  DateTime.fromMillisecondsSinceEpoch(userProfile.dob)
                                ),
                            icon: Icons.calendar_today_outlined,
                          ),

                          const SizedBox(height: 30),

                          // Edit Profile Button
                          ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => EditProfileDialog(
                                  currentUser: UserModel(
                                    uid: user.uid,
                                    fullName: userProfile.fullName,
                                    email: user.email ?? '',
                                    number: userProfile.number,
                                    dob: userProfile.dob,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: AppColor.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is ProfileErrorState) {
                  return Center(child: Text('Error: ${state.message}'));
                }

                return const Center(child: CircularProgressIndicator());
              },
            );
          },
        ),
      ),
    );
  }

  Widget _defaultProfileIcon() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: AppColor.greyShade,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person, 
        size: 80, 
        color: Colors.white,
      ),
    );
  }
}