import 'package:flutter/material.dart';

class TabsTitle extends StatelessWidget {
  const TabsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBar(tabs: [
      Tab(
        child: Text(
          'Leave request',
          style: TextStyle(color: Color(0xFF0143DB)),
        ),
      ),
      Tab(
        child: Text(
          'Fridge',
          style: TextStyle(color: Color(0xFF0143DB)),
        ),
      )
    ]);
  }
}
