import 'package:employee_app/pages/home_pages/components/logout_button.dart';
import 'package:employee_app/pages/home_pages/components/tabs_content.dart';
import 'package:employee_app/pages/home_pages/components/tabs_title.dart';
import 'package:employee_app/pages/home_pages/components/home_title.dart';
import 'package:flutter/material.dart';

class Tabs extends StatelessWidget {
  const Tabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(children: [
            Container(
              padding:
                  EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 10),
              color: Color(0xFF0143DB),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [HomeTitle(), LogoutButton()],
              ),
            ),
            TabsTitle(),
            TabsContent(),
          ]),
        ));
  }
}
