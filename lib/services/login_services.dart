import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_app/models/user/user_save_data.dart';

class LoginService {
  static Future<bool> authenticateUser(
      {required String emailId,
      required String password,
      required String userType}) async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      QuerySnapshot<Map<String, dynamic>> userDataSnap = await _firestore
          .collection('user')
          .where("email", isEqualTo: emailId)
          .where("password", isEqualTo: password)
          .where("type", isEqualTo: userType)
          .get();
      Map map = userDataSnap.docs[0].data();
      UserSaveData().setID(map['email'], map['type'], map['name']);
      print(map);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
