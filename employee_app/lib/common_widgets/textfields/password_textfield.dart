import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController password;
  final Function(String) onChanged;

  final String hint;

  PasswordTextField(
      {required this.password, required this.hint, required this.onChanged});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.password,
      obscureText: _obscure,
      decoration: InputDecoration(
        hintText: widget.hint,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
          child: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            color: Color.fromARGB(255, 134, 124, 124),
          ),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFF0143DB), width: 2)),
      ),
      onChanged: widget.onChanged,
      validator: (value) {
        if (value == '') {
          return '${widget.hint} is required';
        } else if (value!.length < 8) {
          return '${widget.hint} should be atleast >8';
        }
        return null;
      },
    );
  }
}
