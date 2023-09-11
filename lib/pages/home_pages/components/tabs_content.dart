import 'package:flutter/material.dart';
import '../../../models/user/user_save_data.dart';
import '../fridge_management_tab/admin_fridge_management/admin_fridge_management.dart';
import '../fridge_management_tab/employee_fridge_management/employee_fridge_management.dart';
import '../leave_request_tab/admin_leave_request_management/admin_leave_request_management.dart';
import '../leave_request_tab/employee_leave_request_management/employee_leave_request.dart';

class TabsContent extends StatelessWidget {
  const TabsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(children: [
        UserSaveData().getType() == 'Admin'
            ? const AdminLeaveRequestManagementPage()
            : const EmployeeLeaveRequestPage(),
        UserSaveData().getType() == 'Admin'
            ? const AdminFridgeManagementPage()
            : const EmployeeFridgeManagementPage(),
      ]),
    );
  }
}
