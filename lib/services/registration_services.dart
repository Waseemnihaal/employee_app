import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_app/models/user/user_save_data.dart';

class RegistrationServices {
  static Future<bool> firestoreRegistration(
      {required String uid,
      required String name,
      required String email,
      required String password,
      required String type}) async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      await _firestore.collection('user').doc(uid).set(
          {"name": name, "email": email, "password": password, "type": type});
      UserSaveData().setID(email, type, name);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
