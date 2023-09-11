import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../login_pages/login.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushReplacement(PageTransition(
            child: LoginPage(),
            type: PageTransitionType.fade,
            // childCurrent: widget,
            duration: Duration(milliseconds: 600),
            alignment: Alignment.topLeft));
      },
      child: Text(
        'Logout',
        style: TextStyle(color: Color(0xFF0143DB)),
      ),
      style: ElevatedButton.styleFrom(primary: Colors.white),
    );
  }
}
