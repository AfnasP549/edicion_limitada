// ignore_for_file: use_build_context_synchronously

import 'package:edicion_limitada/features/auth/views/service/auth_service.dart';
import 'package:edicion_limitada/features/auth/bloc/auth_bloc.dart';
import 'package:edicion_limitada/common/utils/validation.dart';
import 'package:edicion_limitada/common/widget/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final _emailControll = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  final auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'An email for password reset has been sent to your email')));
            Navigator.pop(context);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Enter Email id'),
                const SizedBox(height: 20),
                Form(
                  key: _formkey,
                  child: CustomTextFormField(
                    labelText: 'Email ID',
                    hintText: 'email',
                    controller: _emailControll,
                    validator: emailValidator,
                  ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return CircularProgressIndicator();
                    }
                    return ElevatedButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  SendPasswordResetLink(
                                      email: _emailControll.text.trim()),
                                );
                            auth.sendPasswordResetLink(_emailControll.text);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please enter a valid email')),
                            );
                          }
                        },
                        child: const Text('Send Email'));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
