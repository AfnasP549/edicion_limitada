import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyBoradType;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final TextStyle? style;
  final int? maxLines;

  const CustomTextFormField(
      {super.key,
      required this.labelText,
      this.hintText = '',
      required this.controller,
      this.keyBoradType = TextInputType.text,
      this.validator,
      this.obscureText = false,
      this.style,
      this.maxLines,});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      controller: controller,
      style: style ?? const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 118, 116, 116),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Color.fromARGB(129, 140, 137, 137)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: validator,
      keyboardType: keyBoradType,
      obscureText: obscureText,
    );
  }
}
