import 'package:employee_app/pages/login_pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await LeaveRequestService.fetchLeaveRequestList();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Sizer(
        builder: (context, orientation, deviceType) {
          return const LoginPage();
        },
      ),
    ),
  );
}





//import 'package:hive/hive.dart';
// part '';

// @HiveType(typeId: 1)
// class User {
//   User({required this.name, required this.email, required this.password});

//   @HiveField(0)
//   String name;

//   @HiveField(1)
//   String email;

//   @HiveField(2)
//   String password;

//   // @override
//   // String toString() {
//   //   return '$name: $age';
//   // }
// }