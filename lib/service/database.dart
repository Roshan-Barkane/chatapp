import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethod {
  // this function we used to create users collection and strore date into userInfoMap
  Future addUserDetails(Map<String, dynamic> userInfoMap, String Id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(Id)
        .set(userInfoMap);
  }

  Future<QuerySnapshot> getUserbyemail(String email) async =>
      await FirebaseFirestore.instance
          .collection('users')
          .where('E-mail', isEqualTo: email)
          .get();
}
