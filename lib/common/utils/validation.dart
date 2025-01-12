String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  final emailRegex = RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email address';
  }
  return null;
}


String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters long';
  }
  return null;
}


