import 'package:flutter/material.dart';

class NameTextField extends StatelessWidget {
  final TextEditingController nameController;
  final Function(String) onChanged;
  NameTextField({required this.nameController, required this.onChanged});

  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: nameController,
      // obscureText: obscure!,
      decoration: InputDecoration(
        hintText: 'Name',
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFF0143DB), width: 2)),
      ),
      onChanged: onChanged,
      validator: (value) {
        if (value == '') {
          return 'Name is required';
        } else if (value!.length < 3) {
          return 'Name should atleast be >2 characters';
        }
        return null;
      },
    );
  }
}
