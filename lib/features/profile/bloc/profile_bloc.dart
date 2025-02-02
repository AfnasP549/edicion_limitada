import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edicion_limitada/common/utils/compress_image.dart';
import 'package:edicion_limitada/features/profile/model/profile_model.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _currentUserId;
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      try {

        if(_currentUserId != event.uid){
          emit(ProfileInitial());
          _currentUserId = event.uid;
        }

        emit(ProfileLoadingState());


        final userDoc = await _fireStore
            .collection('users')
            .doc(event.uid)
            .snapshots()
            .map((snapshot) =>
                snapshot.exists ? UserModel.fromMap(snapshot.data()!) : null)
            .first;

            if(userDoc!=null){
              emit(ProfileLoadedState(userDoc));
            }else{
              final currentUser = _auth.currentUser;
              if(currentUser != null){
                final newUser = UserModel(
                  uid: currentUser.uid, 
                  fullName: currentUser.displayName ?? '', 
                  email: currentUser.email ?? '', 
                  number: 0, 
                  dob: 0);

                  await _fireStore.collection('users').doc(currentUser.uid).set(newUser.toMap());

                  emit(ProfileLoadedState(newUser));
              }
            }
      } catch (e) {
        emit(ProfileErrorState(e.toString()));
      }
    });


    on<ResetProfile>((event, emit)async {
      _currentUserId = null;
      emit(ProfileInitial());
    });



//!update
   on<UpdateProfile>((event, emit) async {
      try {
        emit(ProfileLoadingState());
  
        final currentUser = _auth.currentUser;
        if (currentUser != null) {
          await currentUser.updateDisplayName(event.user.fullName);
        }

        final updatedUser = event.user.copyWith(
          dob: event.selectedDate.millisecondsSinceEpoch,
        );

        final userDoc = _fireStore.collection('users').doc(event.user.uid);
        final docSnapshot = await userDoc.get();
        
        if (docSnapshot.exists) {
          await userDoc.update(updatedUser.toMap());
        } else {
          await userDoc.set(updatedUser.toMap());
        }

        emit(ProfileUpdatedState());
        emit(ProfileLoadedState(updatedUser));
      } catch (e) {
        emit(ProfileErrorState(e.toString()));
      }
    });


//! image
        on<PickProfileImage>((event, emit) async {
      try {
        final imagePicker = ImagePicker();
        final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
        
        if (pickedFile != null) {
          final base64Image = await compressImage(pickedFile.path);
          emit(ProfileImagePickedState(pickedFile.path, base64Image));
        }
      } catch (e) {
        emit(ProfileErrorState(e.toString()));
      }
    });
  }
}
