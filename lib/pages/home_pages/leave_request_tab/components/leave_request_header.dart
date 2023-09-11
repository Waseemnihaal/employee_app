import 'package:employee_app/models/user/user_save_data.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LeaveRequestHeader extends StatelessWidget {
  const LeaveRequestHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 20.w,
              child: Text(
                UserSaveData().getType() == 'Admin' ? 'Name' : 'Leave on',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 20.w,
              child: Text(
                UserSaveData().getType() == 'Admin'
                    ? 'Leave on'
                    : 'Requested on',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 20.w,
              child: const Text(
                'Status',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 5.w,
            )
          ],
        ),
      ),
    );
  }
}
