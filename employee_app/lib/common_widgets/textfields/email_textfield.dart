import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController emailController;
  final Function(String) onChanged;
  EmailTextField({required this.emailController, required this.onChanged});

  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: emailController,
      // obscureText: obscure!,
      decoration: InputDecoration(
        hintText: 'Email ID',
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFF0143DB), width: 2)),
      ),
      onChanged: onChanged,
      validator: (value) {
        if (value == '') {
          return 'Email ID is required';
        } else if (!value!.contains('@') || !value.contains('.com')) {
          return 'Email ID is invalid';
        }
        return null;
      },
    );
  }
}
