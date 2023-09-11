import 'package:flutter/material.dart';
import '../../../models/user/user_save_data.dart';

class HomeTitle extends StatelessWidget {
  const HomeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      UserSaveData().getType() == 'Admin' ? 'Admin' : 'Employee',
      style: TextStyle(
          fontSize: 25, color: Colors.white, fontWeight: FontWeight.w600),
    );
  }
}
