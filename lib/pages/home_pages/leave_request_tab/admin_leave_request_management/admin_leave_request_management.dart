import 'package:employee_app/models/leaves/leaves.dart';
import 'package:employee_app/pages/home_pages/leave_request_tab/components/leave_request_header.dart';
import 'package:employee_app/pages/home_pages/leave_request_tab/admin_leave_request_management/admin_leave_request_list.dart';
import 'package:employee_app/pages/home_pages/leave_request_tab/components/leave_status_filter_dropdown.dart';
import 'package:employee_app/pages/home_pages/leave_request_tab/components/welcome_text.dart';
import 'package:employee_app/services/leave_request_services/admin_leave_request_services.dart';
import 'package:flutter/material.dart';

class AdminLeaveRequestManagementPage extends StatefulWidget {
  const AdminLeaveRequestManagementPage({super.key});

  @override
  State<AdminLeaveRequestManagementPage> createState() =>
      _AdminLeaveRequestManagementPageState();
}

class _AdminLeaveRequestManagementPageState
    extends State<AdminLeaveRequestManagementPage> {
  int ltype = 0;
  List<Leaves> leaveRequestList = [];
  var dropdown = 'All', ddl = ['All', 'Accepted', 'Rejected', 'Pending'];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // leaveRequestList =
    //      LeaveRequestService.fetchLeaveRequestList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                WelcomeText(),
                LeaveStatusDropdown(
                    dropdownValue: dropdown,
                    dropdownList: ddl,
                    onChange: (value) {
                      setState(() {
                        dropdown = value!;
                      });
                      // LeaveRequestService.fetchLeaveRequestList(
                      //     );
                    })
              ],
            ),
            AdminLeaveRequestService.leaves.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: Text(
                        'No Leave request available',
                        style: TextStyle(
                            color: Color(0xFF0143DB),
                            fontWeight: FontWeight.w600,
                            fontSize: 25),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      const LeaveRequestHeader(),
                      AdminLeaveRequestList()
                    ],
                  )
          ],
        ),
      )),
    );
  }
}
