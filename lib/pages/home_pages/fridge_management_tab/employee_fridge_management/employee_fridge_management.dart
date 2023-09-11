import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_app/models/user/user_save_data.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

class EmployeeFridgeManagementPage extends StatefulWidget {
  const EmployeeFridgeManagementPage({super.key});

  @override
  State<EmployeeFridgeManagementPage> createState() =>
      _EmployeeFridgeManagementPageState();
}

class _EmployeeFridgeManagementPageState
    extends State<EmployeeFridgeManagementPage> {
  var foodItems = [
        {"name": "Dairy Milk", "img": "assets/DairyMilk.png", "qty": 0},
        {"name": "Mountain Dew", "img": "assets/mountain_dew.png", "qty": 0},
        {"name": "Oreo", "img": "assets/Oreo.png", "qty": 0},
        {
          "name": "Tata Gluco Plus",
          "img": "assets/tata-gluco-plus.png",
          "qty": 0
        },
        {"name": "Treat", "img": "assets/treat.png", "qty": 0},
      ],
      fil,
      ft,
      ias = true,
      totb = false,
      dd = 'Available',
      ddl = ['Available', 'Taken'];
  int totamt = 0;

  void itemInc(i) {
    setState(() {
      // qty++;
      foodItems[i]['qty'] = int.parse(foodItems[i]['qty'].toString()) + 1;
    });
  }

  void itemDec(i) {
    setState(() {
      //qty--;
      foodItems[i]['qty'] = int.parse(foodItems[i]['qty'].toString()) - 1;
    });
  }

  Future foodList() async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await _firestore
          .collection('food')
          //  .where("email", isEqualTo: sd.getID())
          .get();
      QuerySnapshot querySnapshot1 = await _firestore
          .collection('foodTaken')
          .where("email", isEqualTo: UserSaveData().getID())
          .get();
      setState(() {
        if (dd == 'Available') {
          fil = querySnapshot.docs.map((doc) => doc.data()).toList();
          totb = true;
          totamt = 0;
        } else {
          ft = querySnapshot1.docs.map((doc) => doc.data()).toList();
          for (var i = 0; i < ft.length && totb; i++) {
            totamt += int.parse(ft[i]['Amount'].toString());
          }
          totb = false;
        }
      });
      // print(totamt);
    } catch (e) {
      print(e.toString());
    }
  }

  Future addFoodList(name, qty, uqty, email, date, amt, img) async {
    var id;
    if (name == 'Dairy Milk') {
      id = 'dairy_milk';
    } else if (name == 'Mountain Dew') {
      id = 'mountain_dew';
    } else if (name == 'Oreo') {
      id = 'oreo';
    } else if (name == 'Tata Gluco Plus') {
      id = 'tata_gluco_plus';
    } else if (name == 'Treat') {
      id = 'treat';
    }
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    await _firestore
        .collection('food')
        .where("name", isEqualTo: name)
        .get()
        .then((value) async {
      await _firestore
          .collection('food')
          .doc(id)
          .update({"qty": qty + uqty}).then((value) async {
        //Taken food
        await _firestore.collection('foodTaken').doc(email + date).set({
          "email": email,
          "product": name,
          "Date": date,
          "img": img,
          "qty": -uqty,
          "Amount": -amt
        }).then((value) {
          //   print(value.docs[0].data);
        });
        for (var i = 0; i < foodItems.length; i++) {
          setState(() {
            foodItems[i]['qty'] = 0;
          });
        }
        if (ias) {
          final snackBar = SnackBar(
            content: Text('Items removed successfully'),
            action: SnackBarAction(
              label: 'Hide',
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          ias = false;
        }
      });
    }).onError((error, stackTrace) {
      final snackBar = SnackBar(
        content: Text('Unable to add items'),
        action: SnackBarAction(
          label: 'Hide',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    foodList();
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
                    Text(
                      'Welcome\n         ' +
                          UserSaveData().getName().toString().toUpperCase(),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0143DB)),
                    ),
                    SizedBox(
                      width: 100,
                      child: DropdownButton(
                        isExpanded: true,
                        value: dd,
                        onChanged: (value) {
                          setState(() {
                            dd = value!;
                          });
                        },
                        items: ddl.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Center(child: Text(value)),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                dd == 'Available'
                    ? (fil != null && fil.length > 0)
                        ? Column(
                            children: [
                              for (var i = 0; i < fil.length; i++)
                                Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  height: 70,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all()),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              '${foodItems[i]['img']}',
                                              width: 80,
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${fil[i]['name']}',
                                                  style: TextStyle(
                                                      color: Color(0xFF0143DB),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '₹${fil[i]['price']}',
                                                  style: TextStyle(
                                                    color: Color(0xFF0143DB),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: fil[i]['qty'] == 0
                                              ? Text(
                                                  'Out of stock',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              : Column(
                                                  children: [
                                                    Text(
                                                      'Available Qty',
                                                      // style: TextStyle(
                                                      //     color: Color(0xFF0143DB)),
                                                    ),
                                                    Text(
                                                      '${fil[i]['qty']}',
                                                      style: TextStyle(
                                                          color: HexColor(
                                                              '#0143DB')),
                                                    ),
                                                  ],
                                                ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          )
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 200),
                              child: Text(
                                'No Food available',
                                style: TextStyle(
                                    color: Color(0xFF0143DB),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25),
                              ),
                            ),
                          )
                    : Column(
                        children: [
                          (ft != null && ft.length > 0)
                              ? Column(
                                  children: [
                                    for (var i = 0; i < ft.length; i++)
                                      Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        height: 70,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all()),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    '${ft[i]['img']}',
                                                    width: 80,
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    '${ft[i]['product']}',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF0143DB),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'X ${ft[i]['qty']} = ${ft[i]['Amount']}',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF0143DB),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                )
                              : Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 200),
                                    child: Text(
                                      'No Food Taken History available',
                                      style: TextStyle(
                                          color: Color(0xFF0143DB),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 25),
                                    ),
                                  ),
                                )
                        ],
                      )
              ],
            ),
          )),
          dd == 'Available'
              ? Container(
                  margin: EdgeInsets.only(right: 20, bottom: 30),
                  height: 100.h,
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                          backgroundColor: Color(0xFF0143DB),
                          child: Icon(Icons.remove),
                          onPressed: () {
                            showModalBottomSheet<void>(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
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
                                        padding: EdgeInsets.only(
                                            right: 15, left: 15),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'Remove items from fridge',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 40,
                                            ),
                                            for (var i = 0;
                                                i < foodItems.length;
                                                i++)
                                              Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 20),
                                                height: 70,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all()),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            '${foodItems[i]['img']}',
                                                            width: 80,
                                                          ),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Text(
                                                            '${foodItems[i]['name']}',
                                                            style: TextStyle(
                                                                color: HexColor(
                                                                    '#0143DB'),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          )
                                                        ],
                                                      ),
                                                      Container(
                                                        height: 40,
                                                        width: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors.grey,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                GestureDetector(
                                                                  child:
                                                                      Container(
                                                                    height: 25,
                                                                    width: 25,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      color: int.parse(foodItems[i]['qty'].toString()) <
                                                                              0
                                                                          ? HexColor(
                                                                              '#0143DB')
                                                                          : Colors
                                                                              .grey,
                                                                    ),
                                                                    child: Icon(
                                                                      Icons
                                                                          .remove,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  onTap: () {
                                                                    if (int.parse(
                                                                            foodItems[i]['qty'].toString()) <
                                                                        0) {
                                                                      setState(
                                                                          () {
                                                                        itemInc(
                                                                            i);
                                                                      });
                                                                    }
                                                                  },
                                                                ),
                                                                Text(
                                                                  '${foodItems[i]['qty']}',
                                                                  style: TextStyle(
                                                                      color: HexColor(
                                                                          '#0143DB')),
                                                                ),
                                                                GestureDetector(
                                                                  child: Container(
                                                                      height: 25,
                                                                      width: 25,
                                                                      decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                        color: int.parse(foodItems[i]['qty'].toString()) > -10 &&
                                                                                -int.parse(foodItems[i]['qty'].toString()) < int.parse(fil[i]['qty'].toString())
                                                                            ? Color(0xFF0143DB)
                                                                            : Colors.grey,
                                                                      ),
                                                                      child: Icon(
                                                                        Icons
                                                                            .add,
                                                                        color: Colors
                                                                            .white,
                                                                      )),
                                                                  onTap: () {
                                                                    if (int.parse(foodItems[i]['qty'].toString()) >
                                                                            -10 &&
                                                                        -int.parse(foodItems[i]['qty'].toString()) <
                                                                            int.parse(fil[i]['qty'].toString())) {
                                                                      setState(
                                                                          () {
                                                                        itemDec(
                                                                            i);
                                                                      });
                                                                    }
                                                                  },
                                                                ),
                                                              ]),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            ElevatedButton(
                                              child: Text('Take'),
                                              style: ElevatedButton.styleFrom(
                                                  primary: Color(0xFF0143DB)),
                                              onPressed: () {
                                                for (var i = 0;
                                                    i < foodItems.length;
                                                    i++) {
                                                  if (int.parse(foodItems[i]
                                                              ['qty']
                                                          .toString()) <
                                                      0) {
                                                    addFoodList(
                                                        foodItems[i]['name'],
                                                        fil[i]['qty'],
                                                        foodItems[i]['qty'],
                                                        UserSaveData().getID(),
                                                        DateTime.now()
                                                            .toString(),
                                                        int.parse(foodItems[i]
                                                                    ['qty']
                                                                .toString()) *
                                                            int.parse(fil[i]
                                                                    ['price']
                                                                .toString()),
                                                        foodItems[i]['img']);
                                                  }
                                                }
                                                Navigator.pop(context);
                                                ias = true;
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
              : Container()
        ],
      ),
      bottomNavigationBar: dd == 'Taken'
          ? Container(
              height: 60,
              color: Color(0xFF0143DB),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount: ₹$totamt',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(primary: Colors.white),
                      child: Text(
                        'Pay',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF0143DB),
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
