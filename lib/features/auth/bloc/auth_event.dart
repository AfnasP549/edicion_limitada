// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class SendPasswordResetLink extends AuthEvent{
  final String email;

  SendPasswordResetLink({required this.email});

}

class LoginWithGoogle extends AuthEvent{}

class CreateUserWithEmailAndPassword extends AuthEvent {
  final String email;
  final String password;
  final String fullName;

  CreateUserWithEmailAndPassword({
    required this.email,
    required this.password,
    required this.fullName,
  });
}

class LoginUserWithEmailAndPassword extends AuthEvent {
  final String email;
  final String password;
  LoginUserWithEmailAndPassword(this.email, this.password);
}

class Signout extends AuthEvent{}

class SignOutRequested extends AuthEvent{}
