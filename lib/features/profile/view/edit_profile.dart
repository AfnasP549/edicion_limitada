// ignore_for_file: use_build_context_synchronously

import 'package:edicion_limitada/common/widget/custom_textformfield.dart';
import 'package:edicion_limitada/features/profile/model/profile_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EditProfile extends StatefulWidget {
  final UserModel currentUser;
  final Function(UserModel) onUpdate;

  const EditProfile({
    super.key,
    required this.currentUser,
    required this.onUpdate,
  });

  @override
  State<EditProfile> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfile> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController dobController;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentUser.fullName);
    phoneController = TextEditingController(
        text: widget.currentUser.number == 0 ? '' : widget.currentUser.number.toString());
    dobController = TextEditingController(
        text: widget.currentUser.dob == 0 
            ? '' 
            : DateFormat('dd-MM-yyyy').format(
                DateTime.fromMillisecondsSinceEpoch(widget.currentUser.dob)
              ));
    if (widget.currentUser.dob != 0) {
      selectedDate = DateTime.fromMillisecondsSinceEpoch(widget.currentUser.dob);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    dobController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 23
              ),
              
            ),
            const SizedBox(height: 20),

            CustomTextFormField(labelText: 'Name', controller: nameController),
           
            const SizedBox(height: 16),

            CustomTextFormField(labelText: 'Phone Number', controller: phoneController),
            
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: dobController,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
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
                  onPressed: _updateProfile,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  

//!updating firebase
 Future<void> _updateProfile() async {
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

  if (selectedDate == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select your date of birth')),
    );
    return;
  }

  try {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await currentUser.updateDisplayName(nameController.text);
    }
    final updatedUser = widget.currentUser.copyWith(
      fullName: nameController.text,
      number: int.parse(phoneController.text),
      dob: selectedDate!.millisecondsSinceEpoch,
    );

    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentUser.uid);
//chcking doc exist
    final docSnapshot = await userDoc.get();
    
    if (docSnapshot.exists) {
      await userDoc.update(updatedUser.toMap());
    } else {
      // Create new document
      await userDoc.set(updatedUser.toMap());
    }

    widget.onUpdate(updatedUser);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error updating profile: $e')),
    );
  }
}

//!Date 
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dobController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

}