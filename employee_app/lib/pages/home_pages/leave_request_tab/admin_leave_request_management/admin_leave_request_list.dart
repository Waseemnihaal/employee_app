import 'package:employee_app/models/leaves/leaves.dart';
import 'package:employee_app/models/user/user_save_data.dart';
import 'package:employee_app/services/leave_request_services/admin_leave_request_services.dart';
import 'package:employee_app/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AdminLeaveRequestList extends StatelessWidget {
  const AdminLeaveRequestList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: AdminLeaveRequestService.leaves.length,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          width: 100.w,
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: 20.w,
                    child:
                        Text('${AdminLeaveRequestService.leaves[index].name}')),
                SizedBox(
                    width: 20.w,
                    child:
                        Text('${AdminLeaveRequestService.leaves[index].date}')),
                SizedBox(
                    width: 20.w,
                    child: Text(
                      '${AdminLeaveRequestService.leaves[index].status.result}',
                      style: TextStyle(
                          color:
                              AdminLeaveRequestService.leaves[index].status ==
                                      LeaveStatus.pending
                                  ? Color(0xFF0143DB)
                                  : (AdminLeaveRequestService
                                              .leaves[index].status ==
                                          LeaveStatus.accepted
                                      ? Colors.green
                                      : Colors.red)),
                    )),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 20.w, child: Text('Applied on:')),
                    SizedBox(
                        width: 60.w,
                        child: Text(
                            '${AdminLeaveRequestService.leaves[index].appliedDate}'))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 20.w, child: Text('Leave Type:')),
                    SizedBox(
                        width: 60.w,
                        child: Text(
                            '${AdminLeaveRequestService.leaves[index].leaveType.result}'))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 20.w, child: Text('Reason:')),
                    SizedBox(
                        width: 60.w,
                        child: Text(
                            '${AdminLeaveRequestService.leaves[index].reason}'))
                  ],
                ),
              ),
              if (AdminLeaveRequestService.leaves[index].status ==
                      LeaveStatus.pending &&
                  UserSaveData().getType() == 'Admin')
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          String status = '';
                          status = await AdminLeaveRequestService
                              .leaveRequestUpdateStatus(
                                  doc: AdminLeaveRequestService
                                          .leaves[index].email! +
                                      AdminLeaveRequestService
                                          .leaves[index].date
                                          .toString(),
                                  status: 'Rejected');
                          if (status != '') {
                            Utils().showAppSnackBar(
                                context, 'Hide', status, () {});
                          }
                        },
                        child: Text('Reject'),
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          String status = '';
                          status = await AdminLeaveRequestService
                              .leaveRequestUpdateStatus(
                                  doc: AdminLeaveRequestService
                                          .leaves[index].email! +
                                      AdminLeaveRequestService
                                          .leaves[index].date
                                          .toString(),
                                  status: 'Accepted');
                          if (status != '') {
                            Utils().showAppSnackBar(
                                context, 'Hide', status, () {});
                          }
                        },
                        child: Text('Accept'),
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                      )
                    ],
                  ),
                ),
              if (AdminLeaveRequestService.leaves[index].status !=
                  LeaveStatus.pending)
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${AdminLeaveRequestService.leaves[index].status}',
                      style: TextStyle(
                          color:
                              AdminLeaveRequestService.leaves[index].status ==
                                      LeaveStatus.accepted
                                  ? Colors.green
                                  : Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    )),
            ],
          ),
        );
      },
    );
  }
}
