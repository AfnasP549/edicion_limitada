// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:edicion_limitada/features/auth/views/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<SendPasswordResetLink>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authService.sendPasswordResetLink(event.email);
        emit(AuthSuccess(user: null));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<LoginWithGoogle>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          final userCredential = await _authService.loginWithGoogle();
          emit(AuthSuccess(user: userCredential?.user));
        } catch (e) {
          emit(AuthError(message: e.toString()));
        }
      },
    );

    on<CreateUserWithEmailAndPassword>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authService.createUserWithEmailAndPass(
            event.email, event.password, event.fullName);
        emit(AuthSuccess(user: user));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<LoginUserWithEmailAndPassword>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authService.loginUserWithEmailAndPass(
            event.email, event.password);
        if (user != null) {
          emit(AuthSuccess(user: user));
        } else {
          emit(AuthError(message: 'Incorrect credentials'));
        }
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

//!signout
    on<Signout>(
      (event, emit) async {
       // emit(AuthLoading());
       try {
          await _authService.signout();
          emit(AuthInitial());
        } catch (e) {
          emit(AuthError(message: e.toString()));
        }
      },
    );


  }
}
