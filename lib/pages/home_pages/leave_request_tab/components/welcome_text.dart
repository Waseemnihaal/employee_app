import 'package:flutter/material.dart';

import '../../../../models/user/user_save_data.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Welcome\n         ${UserSaveData().getName().toString().toUpperCase()}',
      style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0143DB)),
    );
  }
}
