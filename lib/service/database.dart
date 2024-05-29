import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethod {
  // this function we used to create users collection and strore date into userInfoMap
  Future addUserDetails(Map<String, dynamic> userInfoMap, String Id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(Id)
        .set(userInfoMap);
  }

// this function we used to get data help to email
  Future<QuerySnapshot> getUserbyemail(String email) async =>
      await FirebaseFirestore.instance
          .collection('users')
          .where('E-mail', isEqualTo: email)
          .get();

// This function we used to search user just like amazon
  Future<QuerySnapshot> Search(String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('SearchKey', isEqualTo: username.substring(0, 1).toUpperCase())
        .get();
  }
}
