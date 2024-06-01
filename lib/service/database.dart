import 'package:chatapp/service/shared_prefirences.data.dart';
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

  createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .get();

    if (snapshot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future addMassage(String chatRoomId, String massageId,
      Map<String, dynamic> massageInfoMap) async {
    await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(massageId)
        .set(massageInfoMap);
  }

  updataLastMessageSend(
      String chatRoomId, Map<String, dynamic> lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  Future<Stream<QuerySnapshot>> getChatRoomMassages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future<QuerySnapshot> getUserInfo(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("Username", isEqualTo: username)
        .get();
  }

  Future<Stream<QuerySnapshot>> getChatRoom() async {
    String? myUsername = await SharedPreferenceHelper().getUserNeme();
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("time", descending: true)
        .where(
          "users",
          arrayContains: myUsername!.toUpperCase(),
        )
        .snapshots();
  }
}
