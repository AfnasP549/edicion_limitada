import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edicion_limitada/features/auth/views/service/auth_service.dart';
import 'package:edicion_limitada/features/profile/model/profile_model.dart';
import 'package:edicion_limitada/features/profile/view/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _auth = AuthService();
  UserModel? userProfile;

  Stream<UserModel?> getUserProfile(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data()!);
      }
      return null;
    });
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
              if (authSnapshot.hasData) {
                final user = authSnapshot.data;

                // this stream builder for getting name and email id from authentication
                return StreamBuilder<UserModel?>(
                  stream: getUserProfile(user!.uid),
                  builder: (context, profileSnapshot) {
                    final userProfile = profileSnapshot.data;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name field remains the same
                        Text(
                          'Name',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Container(
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
                              userProfile?.fullName ?? user.displayName ?? '',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 69, 68, 68),
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),

                        // Email field remains the same
                        SizedBox(height: 10),
                        Text(
                          'Email',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Container(
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
                              user.email ?? '',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 69, 68, 68),
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),

                        // Updated Phone Number field
                        SizedBox(height: 10),
                        Text(
                          'Phone Number',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Container(
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
                              userProfile?.number == 0
                                  ? ''
                                  : userProfile?.number.toString() ?? '',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 69, 68, 68),
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),

                        // Updated DOB field
                        SizedBox(height: 10),
                        Text(
                          'D O B',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Container(
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
                              userProfile?.dob == 0
                                  ? ''
                                  : DateFormat('dd-MM-yyyy').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          userProfile?.dob ?? 0)),
                              style: TextStyle(
                                color: const Color.fromARGB(255, 69, 68, 68),
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),

                        Spacer(),

                        // Edit Profile button with updated UserModel
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => EditProfile(
                                currentUser: UserModel(
                                  uid: user.uid,
                                  fullName:userProfile?.fullName ?? user.displayName ?? '',
                                  email: user.email ?? '',
                                  number: userProfile?.number ?? 0,
                                  dob: userProfile?.dob ?? 0,
                                ),
                                onUpdate: (updatedUser) {},
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50)),
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        )
                      ],
                    );
                  },
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
