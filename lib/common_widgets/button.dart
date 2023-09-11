import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double width;
  // final int userTypeCheck;
  // final String emailCheck;
  // final String passwordCheck;
  final bool disabled;
  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.width,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              disabled ? Colors.grey.withOpacity(0.8) : const Color(0xFF0143DB),
        ),
        onPressed: disabled ? null : onPressed,
        child: Text(text),
      ),
    );
  }
}
