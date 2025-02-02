import 'dart:convert';
import 'dart:io';

import 'package:edicion_limitada/common/widget/custom_textformfield.dart';
import 'package:edicion_limitada/features/profile/model/profile_model.dart';
import 'package:edicion_limitada/features/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EditProfileDialog extends StatelessWidget {
  final UserModel currentUser;

  EditProfileDialog({
    super.key,
    required this.currentUser,
  });

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final ValueNotifier<DateTime?> selectedDate = ValueNotifier<DateTime?>(null);

  @override
  Widget build(BuildContext context) {
    // Initialize controllers
    nameController.text = currentUser.fullName;
    phoneController.text = currentUser.number == 0 ? '' : currentUser.number.toString();
    if (currentUser.dob != 0) {
      selectedDate.value = DateTime.fromMillisecondsSinceEpoch(currentUser.dob);
      dobController.text = DateFormat('dd-MM-yyyy').format(selectedDate.value!);
    }

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdatedState) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          // Trigger profile reload
          context.read<ProfileBloc>().add(LoadProfile(currentUser.uid));
        }
        if (state is ProfileErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 23),
                  ),
                  const SizedBox(height: 20),

                  // Profile Image Picker
                  GestureDetector(
                    onTap: () => context.read<ProfileBloc>().add(PickProfileImage()),
                    child: Center(
                      child: BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, state) {
                          if (state is ProfileImagePickedState) {
                            return ClipOval(
                              child: Image.file(
                                File(state.imagePath),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            );
                          }

                          return currentUser.imageUrl != null
                              ? ClipOval(
                                  child: Image.memory(
                                    base64Decode(currentUser.imageUrl!),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildDefaultImage();
                                    },
                                  ),
                                )
                              : _buildDefaultImage();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Form Fields
                  CustomTextFormField(
                    labelText: 'Name',
                    controller: nameController,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    labelText: 'Phone Number',
                    controller: phoneController,
                    keyBoradType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder<DateTime?>(
                    valueListenable: selectedDate,
                    builder: (context, date, child) {
                      return GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: dobController,
                            decoration: const InputDecoration(
                              labelText: 'Date of Birth',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _updateProfile(context),
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDefaultImage() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.add_a_photo, size: 40),
    );
  }

  void _updateProfile(BuildContext context) {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    if (phoneController.text.isEmpty || phoneController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit phone number')),
      );
      return;
    }

    if (selectedDate.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your date of birth')),
      );
      return;
    }

    String? newImageUrl;
    if (context.read<ProfileBloc>().state is ProfileImagePickedState) {
      final imageState = context.read<ProfileBloc>().state as ProfileImagePickedState;
      newImageUrl = imageState.base64Image;
    }

    final updatedUser = currentUser.copyWith(
      fullName: nameController.text,
      number: int.parse(phoneController.text),
      dob: selectedDate.value!.millisecondsSinceEpoch,
      imageUrl: newImageUrl ?? currentUser.imageUrl,
    );

    context.read<ProfileBloc>().add(UpdateProfile(updatedUser, selectedDate.value!));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      selectedDate.value = picked;
      dobController.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  }
}
