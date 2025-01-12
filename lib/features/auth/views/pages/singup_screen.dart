
import 'package:edicion_limitada/features/auth/bloc/auth_bloc.dart';
import 'package:edicion_limitada/features/auth/views/pages/login_screen.dart';
import 'package:edicion_limitada/common/utils/validation.dart';
import 'package:edicion_limitada/common/widget/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingupScreen extends StatefulWidget {
  const SingupScreen({super.key});

  @override
  State<SingupScreen> createState() => _SingupScreenState();
}

class _SingupScreenState extends State<SingupScreen> {
  final _formkey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AuthSuccess) {
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Sign Up'),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
               
                  const SizedBox(height: 50),
                  //!name
                  CustomTextFormField(
                    labelText: 'Full Name',
                    hintText: 'Type your full name',
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      if (value.length < 2) {
                        return 'Name must be at least 2 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  //!email
                  CustomTextFormField(
                    labelText: 'Email Address',
                    hintText: 'Type your email address',
                    controller: _emailController,
                    keyBoradType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  const SizedBox(height: 20),
                  //!password
                  CustomTextFormField(
                    labelText: 'Password',
                    hintText: 'Type your password',
                    controller: _passController,
                    obscureText: true,
                    maxLines: 1,
                    validator: passwordValidator,
                  ),
                  const SizedBox(height: 20),
                  //!signup button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 91, 158, 225),
                    ),
                    onPressed: _signup,
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('I Already Have an Account'),
                      //!Log in
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()));
                          },
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                                color: Color.fromARGB(255, 91, 158, 225),
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    Color.fromARGB(255, 91, 158, 225)),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  _signup() {
    if (_formkey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            CreateUserWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passController.text.trim(),
                fullName: _nameController.text.trim()),
          );
    }
  }
}
