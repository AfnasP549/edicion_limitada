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

  Widget _buildInfoContainer(String text) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color.fromARGB(255, 197, 197, 197),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Text(
          text,
          style: const TextStyle(
            color: Color.fromARGB(255, 69, 68, 68),
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: StreamBuilder(
            stream: _auth.userStream,
            builder: (context, authSnapshot) {
              if (!authSnapshot.hasData) {
               //
                
                context.read<ProfileBloc>().add(ResetProfile());
                return CircularProgressIndicator();
              }
               final user = authSnapshot.data;
                if (user == null) {
                return const Center(child: Text('No user found'));
              }

               // Load profile for the current user
              context.read<ProfileBloc>().add(LoadProfile(user.uid));



                return BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (state is ProfileLoadedState) {
                      final userProfile = state.user;
                      
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          if(userProfile.imageUrl!=null)
                          Center(
                            child: ClipOval(
                              child: Image.memory(
                                base64Decode(userProfile.imageUrl!),
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace){
                                  return Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: AppColor.greyShade,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.person, size: 60,),
                                  );
                                },
                                ),
                            ),
                          )
                          else
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppColor.greyShade,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.person, size: 60,),
                          ),
                          SizedBox(height: 20,),



                          const Text(
                            'Name',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          _buildInfoContainer(
                            userProfile.fullName 
                          ),

                          const SizedBox(height: 10),
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          _buildInfoContainer(user.email ?? ''),

                          const SizedBox(height: 10),
                          const Text(
                            'Phone Number',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          _buildInfoContainer(
                            userProfile.number == 0
                                ? ''
                                : userProfile.number.toString()
                          ),

                          const SizedBox(height: 10),
                          const Text(
                            'D O B',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          _buildInfoContainer(
                            userProfile.dob == 0
                                ? ''
                                : DateFormat('dd-MM-yyyy').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      userProfile.dob
                                    )
                                  )
                          ),

                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => EditProfileDialog(
                                  currentUser: UserModel(
                                    uid: user.uid,
                                    fullName: userProfile.fullName ,
                                    email: user.email ?? '',
                                    number: userProfile.number ,
                                    dob: userProfile.dob ,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50)
                            ),
                            child: const Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                              ),
                            ),
                          )
                        ],
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
      ),
    );
  }
}