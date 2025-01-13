import 'dart:developer';
import 'package:edicion_limitada/common/utils/validation.dart';
import 'package:edicion_limitada/common/widget/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edicion_limitada/features/auth/bloc/auth_bloc.dart';
import 'package:edicion_limitada/features/auth/views/pages/forgot_screen.dart';
import 'package:edicion_limitada/features/auth/views/pages/singup_screen.dart';
import 'package:edicion_limitada/common/widget/custom_textformfield.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            log('state activated');
            // Navigator.pop(context); // Close loading dialog
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CustomNavBar()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
                    const Text(
                      'Welcome Back',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    const Text('Enter your credentials to login'),
                    const SizedBox(height: 60),
                    //!email
                    CustomTextFormField(
                      labelText: 'Email Address',
                      hintText: 'Type your email address',
                      controller: emailController,
                      validator: emailValidator,
                    ),
                    const SizedBox(height: 20),
                    //!password
                    CustomTextFormField(
                      labelText: 'Password',
                      hintText: 'Type your password',
                      controller: passwordController,
                      obscureText: true,
                      maxLines: 1,
                      validator:passwordValidator,
                    ),
                    const SizedBox(height: 20),
                    //!signin button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 91, 158, 225),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();
                            context.read<AuthBloc>().add(
                                LoginUserWithEmailAndPassword(email, password));
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Sign in',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    //!forgot password
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotScreen()),
                        );
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                            color: Colors.red,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.red),
                      ),
                    ),
                    const Text(
                      '- OR Continue with -',
                      style:
                          TextStyle(color: Color.fromARGB(255, 133, 132, 132)),
                    ),
                    const SizedBox(height: 20),
                    //!google account login
                    GestureDetector(
                      onTap: () {
                        context.read<AuthBloc>().add(LoginWithGoogle());
                      },
                      child: Container(
                        height: 44,
                        width: 108,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: const Color.fromARGB(25, 235, 0, 41),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'image/google1.png',
                                height: 24,
                                width: 24,
                              ),
                            ),
                            const Text(
                              'Google',
                              style: TextStyle(
                                  color: Color.fromARGB(141, 0, 0, 0)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Create an Account'),
                        //!sign Up
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SingupScreen()),
                            );
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Color.fromARGB(235, 91, 158, 225),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    Color.fromARGB(235, 91, 158, 225)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
