import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_app/models/user/user_save_data.dart';
import 'package:employee_app/pages/home_pages/leave_request_tab/components/leave_status_filter_dropdown.dart';
import 'package:employee_app/pages/home_pages/leave_request_tab/components/welcome_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class EmployeeLeaveRequestPage extends StatefulWidget {
  const EmployeeLeaveRequestPage({super.key});

  @override
  State<EmployeeLeaveRequestPage> createState() =>
      _EmployeeLeaveRequestPageState();
}

class _EmployeeLeaveRequestPageState extends State<EmployeeLeaveRequestPage> {
  TextEditingController _reason = TextEditingController();
  var date = '',
      date1 = '',
      dd = 'All',
      ddl = ['All', 'Accepted', 'Rejected', 'Pending'];
  int ltype = 0;
  List LeaveRequestList = [];
  bool isLoading = true;

  Future<bool> isDuplicateUniqueDate(String uniquedate) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('leave')
        .where('Date', isEqualTo: uniquedate)
        .where('email', isEqualTo: UserSaveData().getID())
        .get();
    return query.docs.isNotEmpty;
  }

  Future lea_req(name, email, lty, rea, d) async {
    try {
      if (await isDuplicateUniqueDate(d)) {
        final snackBar = SnackBar(
          content: Text('This date has already a leave request'),
          action: SnackBarAction(
            label: 'Hide',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          _reason.clear();
          date = '';
          date1 = '';
          ltype = 0;
        });
      } else {
        FirebaseFirestore _firestore = FirebaseFirestore.instance;

        await _firestore.collection('leave').doc(email + d).set({
          "name": name,
          "email": email,
          "LeaveType": lty,
          "reason": rea,
          "Date": d,
          "status": "Pending",
          "appliedDate": datead(DateTime.now().toString())
        }).then((value) {
          setState(() {
            _reason.clear();
            date = '';
            date1 = '';
            ltype = 0;
            isLoading = true;
            LeaveRequestList = [];
          });
          final snackBar = SnackBar(
            content: Text('Submitted sucessfully'),
            action: SnackBarAction(
              label: 'Hide',
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      }
    } catch (e) {
      print(e.toString());
      final snackBar = SnackBar(
        content: Text('Unable to submit'),
        action: SnackBarAction(
          label: 'Hide',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future leaveRequestReadData() async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot;
      if (dd == 'All') {
        querySnapshot = await _firestore
            .collection('leave')
            .where("email", isEqualTo: UserSaveData().getID())
            .get();
      } else {
        querySnapshot = await _firestore
            .collection('leave')
            .where("email", isEqualTo: UserSaveData().getID())
            .where("status", isEqualTo: dd)
            .get();
      }
      setState(() {
        LeaveRequestList = querySnapshot.docs.map((doc) => doc.data()).toList();
        isLoading = false;
      });

      // print(lr);
      //     .then((value) {
      //     print(value.docs[0].data());
      //   //  req = value.docs[0].data() as List;
      // });
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  Future lrd(docs, date) async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      await _firestore
          .collection('leave')
          .where(date)
          .get()
          .then((value) async {
        await _firestore.collection('leave').doc(docs).delete().then((value) {
          final snackBar = SnackBar(
            content: Text('Request cancelled successfully'),
            action: SnackBarAction(
              label: 'Hide',
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      });
    } catch (e) {
      print(e.toString());
      final snackBar = SnackBar(
        content: Text('Unable to cancelled request'),
        action: SnackBarAction(
          label: 'Hide',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    super.initState();
    leaveRequestReadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    WelcomeText(),
                    LeaveStatusDropdown(
                        dropdownValue: dd,
                        dropdownList: ddl,
                        onChange: (value) {
                          setState(() {
                            dd = value!;
                          });
                          leaveRequestReadData();
                        }),
                  ],
                ),
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : LeaveRequestList.isNotEmpty
                        ? Column(
                            children: [
                              Container(
                                height: 50,
                                color: Colors.grey,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 20.w,
                                        child: Text(
                                          'Leave on',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20.w,
                                        child: Text(
                                          'Requested On',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20.w,
                                        child: Text(
                                          'Status',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              for (var i = 0; i < LeaveRequestList.length; i++)
                                ExpansionTile(
                                  // height: 70,
                                  // margin:
                                  //     EdgeInsets.only(top: 10, right: 10, left: 10),
                                  // decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(15),
                                  //     border: Border.all()),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // if (lr[index]['status'] == 'pending')
                                      //   Icon(Icons.pending),

                                      SizedBox(
                                          width: 20.w,
                                          child: Text(
                                              '${LeaveRequestList[i]['Date']}')),
                                      SizedBox(
                                          width: 20.w,
                                          child: Text(
                                              '${LeaveRequestList[i]['appliedDate']}')),

                                      SizedBox(
                                          width: 20.w,
                                          child: Text(
                                            '${LeaveRequestList[i]['status']}',
                                            style: TextStyle(
                                                color: LeaveRequestList[i]
                                                            ['status'] ==
                                                        'Pending'
                                                    ? Color(0xFF0143DB)
                                                    : (LeaveRequestList[i]
                                                                ['status'] ==
                                                            'Accepted'
                                                        ? Colors.green
                                                        : Colors.red)),
                                          )),
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              width: 20.w,
                                              child: Text('Name:')),
                                          SizedBox(
                                              width: 60.w,
                                              child: Text(
                                                  '${LeaveRequestList[i]['name']}'))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              width: 20.w,
                                              child: Text('Leave Type:')),
                                          SizedBox(
                                              width: 60.w,
                                              child: Text(
                                                  '${LeaveRequestList[i]['LeaveType']}'))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              width: 20.w,
                                              child: Text('Reason:')),
                                          SizedBox(
                                              width: 60.w,
                                              child: Text(
                                                  '${LeaveRequestList[i]['reason']}'))
                                        ],
                                      ),
                                    ),
                                    if (LeaveRequestList[i]['status'] ==
                                        'Pending')
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            lrd(
                                                LeaveRequestList[i]['email'] +
                                                    LeaveRequestList[i]['Date'],
                                                LeaveRequestList[i]['Date']);
                                          },
                                          child: Text('Cancel'),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.red),
                                        ),
                                      )
                                  ],
                                ),
                            ],
                          )
                        : Center(
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
              ],
            ),
          )),
          Container(
            margin: EdgeInsets.only(right: 20, bottom: 30),
            height: 100.h,
            child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                    backgroundColor: Color(0xFF0143DB),
                    child: Icon(Icons.add),
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return Container(
                              height: 80.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 15, left: 15),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Details for leave request',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Type:',
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 40.w,
                                                child: RadioListTile(
                                                  value: 1,
                                                  groupValue: ltype,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      ltype = value!;
                                                    });
                                                  },
                                                  title: Text('Sick Leave'),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 40.w,
                                                child: RadioListTile(
                                                  value: 2,
                                                  groupValue: ltype,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      ltype = value!;
                                                    });
                                                  },
                                                  title: Text('Casual Leave'),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        controller: _reason,
                                        decoration: InputDecoration(
                                          hintText: 'Reason',
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Color(0xFF0143DB),
                                                  width: 2)),
                                        ),
                                        validator: (value) {
                                          if (value == '') {
                                            return 'Reason is required';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      SfDateRangePicker(
                                        selectionMode:
                                            DateRangePickerSelectionMode.range,
                                        minDate: DateTime.now(),
                                        onSelectionChanged:
                                            (dateRangePickerSelectionChangedArgs) {
                                          print(
                                              dateRangePickerSelectionChangedArgs
                                                  .value);
                                          setState(() {
                                            date =
                                                dateRangePickerSelectionChangedArgs
                                                    .value.startDate
                                                    .toString();
                                            if (dateRangePickerSelectionChangedArgs
                                                    .value.endDate !=
                                                null) {
                                              date1 =
                                                  dateRangePickerSelectionChangedArgs
                                                      .value.endDate
                                                      .toString();
                                            } else if (dateRangePickerSelectionChangedArgs
                                                    .value.startDate ==
                                                dateRangePickerSelectionChangedArgs
                                                    .value.endDate) {
                                              date1 = '';
                                            } else {
                                              date1 = '';
                                            }
                                          });
                                        },
                                      ),
                                      if (date != '')
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('Selected Date:'),
                                            Row(
                                              children: [
                                                Text(datead(date)),
                                                if (date1 != '')
                                                  Text('-' + datead(date1)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      ElevatedButton(
                                        child: Text('Submit'),
                                        style: ElevatedButton.styleFrom(
                                            primary: (_reason.text == '' ||
                                                    ltype == 0 ||
                                                    date == '')
                                                ? Colors.grey
                                                : Color(0xFF0143DB)),
                                        onPressed: () {
                                          if (_reason.text != '' &&
                                              ltype != 0 &&
                                              date != '') {
                                            lea_req(
                                                UserSaveData().getName(),
                                                UserSaveData().getID(),
                                                ltype == 1
                                                    ? 'Sick Leave'
                                                    : 'Casual Leave',
                                                _reason.text,
                                                date1 == ''
                                                    ? datead(date)
                                                    : datead(date) +
                                                        ' - ' +
                                                        datead(date1));
                                            leaveRequestReadData();

                                            Navigator.pop(context);
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                        },
                      );
                    })),
          )
        ],
      ),
      // bottomNavigationBar: Container(
      //   height: 60,
      //   color: Color(0xFF0143DB),
      //   child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      //     Expanded(
      //       child: InkWell(
      //         child: Container(
      //           width: 50.w,
      //           color: ol ? null : Colors.black.withOpacity(0.7),
      //           child: Center(
      //             child: Text(
      //               'Open Leave request',
      //               style: TextStyle(
      //                   fontSize: 15,
      //                   color: Colors.white,
      //                   fontWeight: ol ? FontWeight.bold : null),
      //             ),
      //           ),
      //         ),
      //         onTap: () {
      //           setState(() {
      //             ol = true;
      //           });
      //         },
      //       ),
      //     ),
      //     Expanded(
      //       child: InkWell(
      //         child: Container(
      //           width: 50.w,
      //           color: ol ? Colors.black.withOpacity(0.7) : null,
      //           child: Center(
      //             child: Text(
      //               'Closed Leave request',
      //               style: TextStyle(
      //                   fontSize: 15,
      //                   color: Colors.white,
      //                   fontWeight: ol ? null : FontWeight.bold),
      //             ),
      //           ),
      //         ),
      //         onTap: () {
      //           setState(() {
      //             ol = false;
      //           });
      //         },
      //       ),
      //     )
      //   ]),
      // ),
    );
  }
}

String datead(d) {
  DateTime d1 = DateTime.parse(d);
  final DateFormat formatter = DateFormat('dd-MMM-yy');
  String res = formatter.format(d1);
  return res;
}
