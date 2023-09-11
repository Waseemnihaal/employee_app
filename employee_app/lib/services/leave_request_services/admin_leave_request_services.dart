import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_app/models/leaves/leaves.dart';
import 'package:employee_app/models/user/user_save_data.dart';

class AdminLeaveRequestService {
  static List<Leaves> leaves = [];
  static Future<List<Leaves>> fetchLeaveRequestList() async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot;
      // if (dropdown == 'All') {
      if (UserSaveData().getType() == 'Admin') {
        querySnapshot = await _firestore.collection('leave').get();
      } else {
        querySnapshot = await _firestore
            .collection('leave')
            .where("email", isEqualTo: UserSaveData().getID())
            .get();
      }

      LeaveStatus _leaveType(String type) {
        switch (type) {
          case 'Accepeted':
            return LeaveStatus.accepted;
          case 'Rejected':
            return LeaveStatus.declined;
          default:
            return LeaveStatus.pending;
        }
      }

      List data = querySnapshot.docs.map((doc) => doc.data()).toList();
      print('!!!!!!');
      print(data.toString());
      for (var element in data) {
        print(element);
        leaves.add(Leaves(
            name: element['name'],
            reason: element['reason'],
            appliedDate: element['appliedDate'],
            date: element['Date'],
            leaveType: element['LeaveType'] == 'Sick Leave'
                ? LeaveType.sick
                : LeaveType.casual,
            status: _leaveType(element['status'])));
      }
      print('leaves - $leaves');
      return leaves;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<String> leaveRequestUpdateStatus(
      {required String doc, required String status}) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore
        .collection('leave')
        .doc(doc)
        .update({"status": status}).then((value) {
      if (status != 'Pending') {
        if (status == 'Accepted') {
          return 'Accepted sucessfully';
        } else {
          return 'Rejected sucessfully';
        }
      }
    }).onError((error, stackTrace) {
      return 'Unfortunately $status not executed';
    });
    return 'Unfortunately $status not executed';
  }
}
